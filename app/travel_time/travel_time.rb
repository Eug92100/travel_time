module TravelTime 
  def self.get_travel_data(origin_address, destination_address)
    mapquest_url = 'https://developer.citymapper.com/api/1/traveltime/'
    query_hash = create_query_hash(origin_address, destination_address)
    response = Faraday.get(mapquest_url, query_hash)
    return nil unless response.status == 200
    parsed_response = JSON.parse(response.body)    
    return parsed_response['travel_time_minutes']
  end

  def self.create_query_hash(origin_address, destination_address)
    { "startcoord": get_coordinates(origin_address),
      "endcoord": get_coordinates(destination_address),
      "time_type": "arrival",
      "key": ENV.fetch('CITYMAPPER_KEY')
    }
  end

  def self.get_coordinates(address)
    Geocoder.search(address).first.coordinates.join(',')
  end
  
end
