class Booking < ApplicationRecord
  before_save :set_cancelled_at_timestamp

  belongs_to :user
  belongs_to :event_instance

  STATUSES = %w[
    pending
    confirmed
    completed
    cancelled_by_teacher
    cancelled_by_student
    rejected_by_teacher
    ]

  STATES = %w[paid unpaid waived]
  CANCELLERS = %w[teacher student]

  validates :status, inclusion: { in: STATUSES }
  validates :state, presence: true, unless: -> {
    status == "pending" ||
    waitlisted? ||
    (status == "cancelled_by_student" && cancelled_before_policy?) ||
    status == "rejected_by_teacher"
  }

  validates :cancelled_by, inclusion: { in: CANCELLERS }, allow_nil: true, if: :cancelled_status?
  validate :unique_booking_per_event_instance

  private

  def cancelled_before_policy?
    return false unless status == "cancelled_by_student"
    return false unless cancelled_at && event_instance.cancellation_deadline

    cancelled_at <= event_instance.cancellation_deadline
  end

  def set_cancelled_at_timestamp
    if status_changed? && cancelled_status? && cancelled_at.nil?
      self.cancelled_at = Time.current
    end
  end

  def cancelled_status?
    status.in?(%w[cancelled_by_student cancelled_by_teacher])
  end

  def state_required?
    # These statuses must have a state
    %w[confirmed cancelled].include?(status)
  end

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
