class CreateReservations < ActiveRecord::Migration
  def change
    create_table :reservations do |t|
      t.integer :renter_id
      t.references :space
      t.datetime :start_time
      t.datetime :end_time
      t.integer :num_people
      t.text :intended_use

      t.timestamps
    end
  end
end
