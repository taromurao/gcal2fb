require 'spec_helper.rb'

module Gcal2Fb
  describe Fb do
    let(:sample_data) { Generator::SampleData.new }
    let(:sample_events) { sample_data.events(10) }
    let(:sample_data_raw) { sample_data.get_data_raw(sample_events) }
    let(:sample_data_nil) { sample_data.get_data_raw(sample_data.events(0)) }
    let(:fb) { Fb.new }
    let(:page_graph) { mock('page_graph') }
    
    describe '#format' do
      it 'has title' do
        fb.format(sample_events).should include("<p>Title: #{sample_events[0]['title']}</p>")
      end
      
      it 'has start and end times' do
        fb.format(sample_events).should include("<p>Time: #{sample_events[0]['start_time']} - #{sample_events[0]['end_time']}</p>")
      end
      
      it 'has location' do
        fb.format(sample_events).should include("<p>Location: #{sample_events[0]['location']}</p>")
      end
      
      it 'has details' do
        fb.format(sample_events).should include("<p>Details: #{sample_events[0]['details']}</p>")
      end
    end
    
    describe '#remind_users' do
      it 'posts events on FB Page' do
        Koala::Facebook::API.stub(:new) { page_graph }
        page_graph.stub(:put_connections) { true }
        page_graph.should_receive(:put_connections)
        fb.remind_users(sample_events)
      end
  
      context 'fails to post' do
        it 'raises error' do
          Koala::Facebook::API.stub(:new) { page_graph }
          page_graph.stub(:put_connections) { nil }
          expect{fb.remind_users(sample_events)}.to raise_error('Posting events on FB failed.')
        end
      end
    end
    
    describe '#notify_admin' do
      it 'notifies admin'
    end 
  end
end