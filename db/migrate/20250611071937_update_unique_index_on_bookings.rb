class UpdateUniqueIndexOnBookings < ActiveRecord::Migration[7.1]
  def change
    remove_index :bookings, name: "index_bookings_on_user_id_and_event_instance_id"

    add_index :bookings, [:user_id, :event_instance_id],
              unique: true,
              where: "status NOT IN ('cancelled_by_student', 'cancelled_by_teacher')",
              name: "index_bookings_on_user_and_event_instance_active_only"
  end

end
