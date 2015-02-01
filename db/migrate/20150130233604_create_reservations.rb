class CreateReservations < ActiveRecord::Migration
  def change
    create_table :reservations do |t|
      t.integer :table_number
      t.datetime :start_at
      t.datetime :end_at

      t.timestamps
    end
  end
end
