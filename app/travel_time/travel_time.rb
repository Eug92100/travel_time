# frozen_string_literal: true

module TravelTime
  def self.get_travel_data(origin_address, destination_address, time_of_arrival = nil)
    mapquest_url = 'https://developer.citymapper.com/api/1/traveltime/'
    query_hash = create_query_hash(origin_address, destination_address, time_of_arrival)
    response = Faraday.get(mapquest_url, query_hash)
    return nil unless response.status == 200 && query_hash

    parsed_response = JSON.parse(response.body)
    parsed_response['travel_time_minutes']
  end

  def self.create_query_hash(origin_address, destination_address, time_of_arrival = nil)
    if Geocoder.search(origin_address).first &&  Geocoder.search(destination_address).first
      query_hash = { "startcoord": get_coordinates(origin_address),
                     "endcoord": get_coordinates(destination_address),
                     "key": ENV.fetch('CITYMAPPER_KEY') }
      if time_of_arrival
        query_hash[:time] = time_of_arrival.to_s
        query_hash[:time_type] = 'arrival'
      end
    end    
    query_hash
  end

  def self.get_coordinates(address)
    Geocoder.search(address).first.coordinates.join(',')
  end
end
