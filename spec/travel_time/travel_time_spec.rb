require 'rails_helper'

describe TravelTime do
  let(:origin_address) { '84 boulevard de la republique, 92100 Boulogne-Billancourt' }
  let(:destination_address) { "1 rue Surcouf, Paris" }
  let(:expected_hash) { { "startcoord": '48.8333906,2.2448635',
                          "endcoord": '48.8622011,2.3093474',
                          "time_type": 'arrival',
                          "key": ENV.fetch('CITYMAPPER_KEY') } } 
  describe '#create_query_hash' do

    it 'creates a hash' do
      expect(TravelTime.create_query_hash(origin_address, destination_address)).to eq expected_hash
    end
  end

  describe '#get_travel_data' do
    let(:request_url) { 'https://developer.citymapper.com/api/1/traveltime/' }
    context 'when the status of the response is not 200' do
      before do
        faraday_response = instance_double("Faraday::Response")
        allow(faraday_response).to receive(:status).with(no_args).and_return(400)
        allow(Faraday).to receive(:get).with(request_url, expected_hash).and_return(faraday_response)
      end
      it 'returns nil' do
        expect(TravelTime.get_travel_data(origin_address, destination_address)).to eq nil
      end
    end
    context 'when the statuts is 200' do
      before do
        faraday_response = instance_double("Faraday::Response")
        allow(faraday_response).to receive(:body).with(no_args).and_return(response)
        allow(faraday_response).to receive(:status).with(no_args).and_return(200)
        allow(Faraday).to receive(:get).with(request_url, expected_hash).and_return(faraday_response)
      end
      let!(:response) do
        "{\"travel_time_minutes\": 31}"
      end
      
      it 'returns the travel duration' do
        expect(TravelTime.get_travel_data(origin_address, destination_address)).to eq 31
      end
    

      context 'when you give coordinates instead of addresses' do
        let(:startcoord) { '48.8333906,2.2448635' } 
        let(:endcoord) { '48.8622011,2.3093474' } 
        it 'returns the travel duration' do
          expect(TravelTime.get_travel_data(startcoord, endcoord)).to eq 31
        end
      end
    end
    
  end
end
