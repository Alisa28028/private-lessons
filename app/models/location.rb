class Location < ApplicationRecord
  belongs_to :user
  validates :name, presence: true, uniqueness: true

  has_many :events
  # validates :address, presence: true
end
