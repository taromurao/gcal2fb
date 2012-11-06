require 'spec_helper.rb'

module Gcal2Fb
  describe Reminder do
    let(:sample_events) { Generator::SampleData.new.events(10)}
    let(:reminder) { Reminder.new }
    let(:gcal) { mock(:gcal) }
    let(:fb) { mock(:fb).as_null_object }
    
    describe '#run' do
      before(:each) do
        Gcal.stub(:new) { gcal }
        Fb.stub(:new) { fb }
        gcal.stub(:events) { sample_events }
      end
      
      it 'fetches events from GCal' do
        gcal.should_receive(:events)
        reminder.run
      end
      
      context 'could not fetch data from Gcal' do
        it 'notifies admin with the error message' do
          gcal.stub(:events).and_raise('Error')
          fb.should_receive(:notify_admin).with('Error')
          reminder.run
        end
      end
      
      context 'connection to GCal was successful, but no events were found' do
        it 'aborts the program' do
          gcal.stub(:events) { nil }
          fb.should_not_receive(:remind_users)
          reminder.run
        end
      end
      
      it 'posts event reminder on FB' do
        fb.should_receive(:remind_users)
        reminder.run
      end
      
      context 'posting message on FB failed' do
        it 'notifies admin with the error message' do
          fb.stub('remind_users').and_raise('Error')
          fb.should_receive(:notify_admin).with('Error')
          reminder.run
        end
      end
    end
  end
end