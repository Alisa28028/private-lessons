class AddUniqueIndexToBookingsOnUserAndEventInstance < ActiveRecord::Migration[7.1]
  def change
    add_index :bookings, [:user_id, :event_instance_id], unique: true
  end
end
