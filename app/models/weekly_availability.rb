class WeeklyAvailability < ApplicationRecord
  belongs_to :user
  belongs_to :studio, optional: true

  enum day: {
    sunday: 0, monday: 1, tuesday: 2,
    wednesday: 3, thursday: 4, friday: 5, saturday: 6
  }

  attr_accessor :start_time_str, :end_time_str

  before_validation :parse_time_strings

  validates :day, :start_time, :end_time, :style, presence: true

  def parse_time_strings
    if start_time_str.present?
      self.start_time = Time.zone.parse(start_time_str).change(year: 2000, month: 1, day: 1)
    end

    if end_time_str.present?
      self.end_time = Time.zone.parse(end_time_str).change(year: 2000, month: 1, day: 1)
    end
  end
end
