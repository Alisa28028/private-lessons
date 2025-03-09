class RemoveEventIdFromBookings < ActiveRecord::Migration[7.1]
  def change
    remove_reference :bookings, :event, null: false, foreign_key: true
  end
end
