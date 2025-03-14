class AddWaitlistedToBookings < ActiveRecord::Migration[7.1]
  def change
    add_column :bookings, :waitlisted, :boolean, default: false, null: false
  end
end
