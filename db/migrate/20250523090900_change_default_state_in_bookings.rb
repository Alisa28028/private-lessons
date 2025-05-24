class ChangeDefaultStateInBookings < ActiveRecord::Migration[7.1]
  def change
    change_column_default :bookings, :state, from: "pending", to: "upaid"
  end
end
