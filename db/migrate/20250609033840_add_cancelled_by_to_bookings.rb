class AddCancelledByToBookings < ActiveRecord::Migration[7.1]
  def change
    add_column :bookings, :cancelled_by, :string
  end
end
