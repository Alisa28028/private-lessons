class EventInstance < ApplicationRecord
  belongs_to :event
  has_many :bookings
  validates :date, presence: true
  validates :start_time, presence: true

  # validates :capacity
  # validates :price
  # validates :duration

  def spots_left
    capacity - bookings.count
  end
end
