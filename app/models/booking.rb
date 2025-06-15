class Booking < ApplicationRecord
  before_save :set_cancelled_at_timestamp
  before_save :clear_payment_state_if_student_cancelled_early


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

  def cancelled?
    status.in?(%w[cancelled_by_student cancelled_by_teacher])
  end


  def cancelled_before_policy?
    return false unless status == "cancelled_by_student"
    return false unless cancelled_at && event_instance.cancellation_policy_duration

    cancelled_at <= event_instance.cancellation_policy_duration
  end

  private

  def set_cancelled_at_timestamp
    if status_changed? && cancelled_status? && cancelled_at.nil?
      self.cancelled_at = Time.current
    end
  end

  def clear_payment_state_if_student_cancelled_early
    return unless cancelled_by == "student" && status == "cancelled_by_student"
    return unless state == "unpaid"
    return unless cancelled_at.present?

    # Replace with your actual policy window logic
    policy_deadline = event_instance.start_time - event_instance.event.cancellation_policy_duration.hours

    if cancelled_at < policy_deadline
      self.state = nil
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
    return if cancelled?
    existing_booking = Booking.where(user_id: user_id, event_instance_id: event_instance_id)
                              .where.not(id: id)
                              .where.not(status: %w[cancelled_by_student cancelled_by_teacher])
                              .first

    return unless existing_booking
         Rails.logger.info "🧪 Booking check — Found existing: #{existing_booking&.id}, status: #{existing_booking&.status}"
      if existing_booking.waitlisted?
        errors.add(:user_id, "is already on the waitlist for this event.")
      else
        errors.add(:user_id, "has already booked this event.")

    end
  end
end
