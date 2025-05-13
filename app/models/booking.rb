class Booking < ApplicationRecord
  belongs_to :user
  belongs_to :event_instance

  validates :state, presence: true # pending, paid, cancelled

  validate :unique_booking_per_event_instance

  private

  def unique_booking_per_event_instance
    existing_booking = Booking.where(user_id: user_id, event_instance_id: event_instance_id)
                              .where.not(id: id)
                              .first

    if existing_booking
      if existing_booking.waitlisted?
        errors.add(:user_id, "is already on the waitlist for this event.")
      else
        errors.add(:user_id, "has already booked this event.")
      end
    end
  end
end
