class EventInstance < ApplicationRecord
  belongs_to :event
  belongs_to :location, optional: true
  has_many :bookings
  has_many :likes, dependent: :destroy
  has_many :liked_users, through: :likes, source: :user
  has_many :posts

  validates :date, presence: true
  validates :start_time, presence: true
  # validates :cancellation_policy_duration, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  has_many :videos, dependent: :destroy
  monetize :price_cents, allow_nil: true
  accepts_nested_attributes_for :event
  has_many_attached :photos
  has_many_attached :videos

  attr_accessor :location_name

  # validates :capacity
  # validates :price
  # validates :duration


  before_validation :apply_default_cancellation_policy, on: :create
  # Set default price from event if price is not provided for event instance
  before_validation :set_default_price, on: :create
  before_destroy :destroy_event_if_last_instance

  before_validation :inherit_approval_mode, on: :create

  def inherit_approval_mode
    self.approval_mode ||= event&.approval_mode
  end

  def apply_default_cancellation_policy
    if cancellation_policy_duration.nil? && event.present?
      self.cancellation_policy_duration = event.cancellation_policy_duration
    end
  end

  def set_default_price
    self.price_cents ||= event.price_cents if event
  end

  def payment_obligation_on_booking?
    self[:payment_obligation_on_booking].nil? ? event.payment_obligation_on_booking? : self[:payment_obligation_on_booking]
  end


  before_save :set_end_time_from_duration

def spots_left
  effective_capacity = capacity || event&.capacity || 0

  spots = effective_capacity - bookings.where(waitlisted: false)
                                       .where.not(status: ["cancelled_by_student", "cancelled_by_teacher", "rejected_by_teacher", "pending"])
                                       .count

  spots.negative? ? 0 : spots
end


  def active_bookings_count
    bookings.where(waitlisted: false).where.not(status: ["cancelled_by_student", "cancelled_by_teacher", "rejected_by_teacher", "pending"]).count
  end


  def effective_capacity
    capacity || event.default_capacity
  end

  def effective_price
    price || event.price
  end

  def effective_approval_mode
    self[:approval_mode] || event.approval_mode
  end

  def active_bookings_count
    bookings.where(waitlisted: false, status: 'confirmed').count

  end

  private

  def recurring_weekly?
    recurrence_type == "every-week"
  end

  def set_end_time_from_duration
    return if start_time.nil? || event.duration.nil?
    self.end_time = start_time + event.duration.minutes
  end

  def destroy_event_if_last_instance
    if event.event_instances.count == 1
      event.destroy
    end
  end

end
