class EventInstance < ApplicationRecord
  belongs_to :event

  validates :date, :start_time, :end_time, :duration, presence: true
end
