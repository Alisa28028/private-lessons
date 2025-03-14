class AddJoinedAtToBookings < ActiveRecord::Migration[7.1]
  def change
    add_column :bookings, :joined_at, :datetime
  end
end
