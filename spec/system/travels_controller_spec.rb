# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TravelsController, type: :system do
  context 'when visiting page new' do
    let(:destination_address) { 'SW9 7QA, London' }
    let(:origin_address) { '65 Leonard Street, London' }
    before do
      visit '/travels/new'
    end
    it '' do
      expected_content = "What's your travel time?\nStarting from:\n"
      expect(page).to have_content expected_content
    end

    context 'when filling all the parameters' do
      let(:date_hour) { '22' }
      let(:date_minute) { '30' }
      let(:arrival_datetime) { DateTime.now.change(hour: 22, min: 30) }

      before do
        allow(TravelTime).to receive(:get_travel_data).with(origin_address, destination_address, arrival_datetime).and_return(52)
        fill_in 'destination_address', with: destination_address
        select date_hour, from: 'date_hour'
        select date_minute, from: 'date_minute'
        select '10 min', from: 'travel_meeting_duration'
        click_on 'Search'
      end

      it 'creates a new Travel object' do
        expected_content = 'It worked! Your travel time is 52 min'
        page.has_selector?('.alert')
        expect(page).to have_content expected_content
        expect(Travel.all.count).to eq 1
        expect(Travel.all.first.destination_address).to eq(destination_address)
        expect(Travel.all.first.origin_address).to eq(origin_address)
        expect(Travel.all.first.arrival_time).to eq(arrival_datetime)
      end
    end
  end
end
