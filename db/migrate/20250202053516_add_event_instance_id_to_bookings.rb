class AddEventInstanceIdToBookings < ActiveRecord::Migration[7.1]
  def change
    add_column :bookings, :event_instance_id, :integer
  end
end
