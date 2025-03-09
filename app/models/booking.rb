class Booking < ApplicationRecord
  belongs_to :user

  belongs_to :event_instance
  validates :state, presence: true # pending, paid, cancelled
end
