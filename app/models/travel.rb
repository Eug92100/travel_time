# frozen_string_literal: true

class Travel < ApplicationRecord
  validates_presence_of :origin_address, :destination_address, message: "Can't be left empty"
  validates :meeting_duration, numericality: { other_than: 0 }
  validates_datetime :arrival_time,
                     after: DateTime.now
end
