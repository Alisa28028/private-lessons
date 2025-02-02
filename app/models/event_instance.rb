class EventInstance < ApplicationRecord
  belongs_to :event
  validates :date, presence: true
  validates :start_time, presence: true
end
