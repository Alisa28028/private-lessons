class ChangeEventInstanceIdInBookings < ActiveRecord::Migration[7.1]
  def change
    change_column :bookings, :event_instance_id, :bigint
  end
end
