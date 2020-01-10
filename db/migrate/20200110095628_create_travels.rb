class CreateTravels < ActiveRecord::Migration[6.0]
  def change
    create_table :travels do |t|
      t.string :origin_address
      t.string :destination_address
      t.decimal :travel_time, precision: 5, scale: 2
      t.decimal :meeting_duration, precision: 5, scale: 2
      t.datetime :arrival_time
    end
  end
end
