require 'rails_helper'

RSpec.describe Travel, type: :model do
  let(:destination_address) { 'SW9 7QA, London' }
  let(:origin_address) { '65 Leonard Street, London' }
  let(:arrival_datetime) { DateTime.now + 2.hours }
  context 'when all the params are right' do
    it 'creates a new travel object' do
      travel = Travel.new(origin_address: origin_address,
                          destination_address: destination_address, 
                          arrival_time: arrival_datetime,
                          meeting_duration: 10,
                          travel_time: 51)
      travel.save
      expect(travel.errors.any?).to eq false
      expect(Travel.all.count).to eq 1
      expect(Travel.all.first).to eq travel
    end
  end

  context 'when the destination address and the origin address are missing' do
    it 'throws an error' do
      expected_error = "Origin address Can't be left empty\nDestination address Can't be left empty"
      travel = Travel.new(arrival_time: arrival_datetime,
                          meeting_duration: 10,
                          travel_time: 51)
      travel.save
      expect(travel.errors.any?).to eq true
      expect(travel.errors.full_messages.join("\n")).to eq expected_error
    end
  end
  context 'when the arrival time is not in the datetime format' do
    it 'throws an error' do
      travel = Travel.new(origin_address: origin_address, 
                          destination_address: destination_address,
                          arrival_time: "23/30/3000 33:34",
                          meeting_duration: 10,
                          travel_time: 51)
      travel.save
      expect(travel.errors.any?).to eq true
      expect(travel.errors.messages).to eq :arrival_time => ["is not a valid datetime"]
    end
  end
  context 'when the arrival time is before the current time' do
    it 'throws an error' do
      travel = Travel.new(origin_address: origin_address, 
                          destination_address: destination_address,
                          arrival_time: DateTime.new(2000, 0o1, 13, 20, 20),
                          meeting_duration: 10,
                          travel_time: 51)
      travel.save
      expect(travel.errors.any?).to eq true
      expect(travel.errors.messages).to eq :arrival_time => ["must be in the future"]
    end
  end

  context 'when the meeting time is 0' do
    it 'throws an error' do
      travel = Travel.new(origin_address: origin_address, 
                          destination_address: destination_address,
                          arrival_time: arrival_datetime,
                          meeting_duration: 0,
                          travel_time: 51)
      travel.save
      expect(travel.errors.any?).to eq true
      expect(travel.errors.full_messages.first).to eq "Meeting duration must be other than 0"
    end
  end
end
