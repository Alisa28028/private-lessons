class EventInstance < ApplicationRecord
  belongs_to :event
  validates :start_time, presence: true
end
