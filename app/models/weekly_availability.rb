class WeeklyAvailability < ApplicationRecord
  belongs_to :user

  enum day: {
    sunday: 0, monday: 1, tuesday: 2,
    wednesday: 3, thursday: 4, friday: 5, saturday: 6
  }

  validates :day, :start_time, :end_time, :style, presence: true
end
