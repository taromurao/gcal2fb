require 'spec_helper.rb'

module Gcal2Fb
  describe Gcal do
    let(:sample_data) { Generator::SampleData.new }
    let(:sample_events) { sample_data.events(10) }
    let(:sample_data_raw) { sample_data.get_data_raw(sample_events) }
    let(:sample_data_nil) { sample_data.get_data_raw(sample_data.events(0)) }
    let(:gcal) { Gcal.new }
    let(:http) { mock('http') }
    let(:res) { mock('res') }
    
    before(:each) do
      gcal.stub(:events_json)
      Net::HTTP.stub(:new) { http }
      http.stub(:start) { res }
    end
    
    describe '#data_raw' do
      it 'fetches event data from GCal' do
        res.stub(:code) { '200' }
        res.stub(:body) { sample_data_raw }
        gcal.data_raw.should == JSON.parse(sample_data_raw)
      end
    
      context 'fails to fetch evets' do
        it 'notifies admin' do
          res.stub(:code) { '400' }
          expect{gcal.data_raw}.to raise_error('Failed to connect to GCal API')
        end
      end
    end
    
    describe '#events' do
      it 'extracts only relevant information from raw GCal data' do
        res.stub(:code) { '200' }
        res.stub(:body) { sample_data_raw }
        gcal.events.should == sample_events
      end
  
      context 'has no events' do
        it 'simply abort the program' do
          res.stub(:code) { '200' }
          res.stub(:body) { sample_data_nil }
          gcal.events.should == nil
        end
      end
    end
  end
end