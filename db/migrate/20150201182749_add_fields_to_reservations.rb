class AddFieldsToReservations < ActiveRecord::Migration
  def change
    add_column :reservations, :phone, :string
    add_column :reservations, :name, :string
  end
end
