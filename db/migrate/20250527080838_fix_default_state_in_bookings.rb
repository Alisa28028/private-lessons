class FixDefaultStateInBookings < ActiveRecord::Migration[7.1]
  def change
    change_column_default :bookings, :state, from: "upaid", to: "unpaid"
  end
end
