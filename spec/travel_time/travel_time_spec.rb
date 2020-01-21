# frozen_string_literal: true

require 'rails_helper'

describe TravelTime do
  let(:origin_address) { '84 boulevard de la republique, 92100 Boulogne-Billancourt' }
  let(:destination_address) { '1 rue Surcouf, Paris' }
  let(:time_of_arrival) { DateTime.new(2019, 0o1, 0o1, 22) }
  let(:expected_hash) do
    { 
      "startcoord": '48.8333906,2.2448635',
      "endcoord": '48.8622011,2.3093474',
      "key": ENV.fetch('CITYMAPPER_KEY') 
    }
  end
  let(:expected_hash_time) do
    { 
      "startcoord": '48.8333906,2.2448635',
      "endcoord": '48.8622011,2.3093474',
      "time": time_of_arrival.to_s,
      "time_type": 'arrival',
      "key": ENV.fetch('CITYMAPPER_KEY') 
    }
  end
  describe '#create_query_hash' do
    context 'when there is no time of arrival specified' do
      it 'creates a hash' do
        expect(TravelTime.create_query_hash(origin_address, destination_address)).to eq expected_hash
      end
    end

    context 'when there is a time of arrival' do
      it 'creates a hash' do
        expect(TravelTime.create_query_hash(origin_address, destination_address, time_of_arrival)).to eq expected_hash_time
      end
    end
  end

  describe '#get_travel_data' do
    let(:request_url) { 'https://developer.citymapper.com/api/1/traveltime/' }
    let(:faraday_response) { instance_double('Faraday::Response') }
    context 'when the status of the response is not 200' do
      before do
        allow(faraday_response).to receive(:status).with(no_args).and_return(400)
        allow(Faraday).to receive(:get).with(request_url, expected_hash).and_return(faraday_response)
      end
      it 'returns nil' do
        expect(TravelTime.get_travel_data(origin_address, destination_address)).to eq nil
      end
    end
    context 'when the status is 200' do
      before do
        allow(faraday_response).to receive(:body).with(no_args).and_return(response)
        allow(faraday_response).to receive(:status).with(no_args).and_return(200)
        allow(Faraday).to receive(:get).with(request_url, expected_hash).and_return(faraday_response)
      end
      let!(:response) do
        '{"travel_time_minutes": 31}'
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
    context 'when you get a status 200 and send an arrival time' do
      before do
        allow(faraday_response).to receive(:body).with(no_args).and_return(response)
        allow(faraday_response).to receive(:status).with(no_args).and_return(200)
        allow(Faraday).to receive(:get).with(request_url, expected_hash_time).and_return(faraday_response)
      end
      let!(:response) do
        '{"travel_time_minutes": 29}'
      end
      it 'returns the travel duration' do
        expect(TravelTime.get_travel_data(origin_address, destination_address, time_of_arrival)).to eq 29
      end
    end
    context 'when Geocoder can\'t find the address' do
      let(:origin_address_wrong) { '84 rue republique, 92100 Billancourt' }
      let(:destination_address_wrong) { '1 rue de Surcouf, Paris' }
      it 'returns the travel duration' do
        expect(TravelTime.get_travel_data(origin_address_wrong, destination_address_wrong, time_of_arrival)).to eq nil
      end
    end
  end
end
