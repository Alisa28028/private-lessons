class Location < ApplicationRecord
  validates :name, presence: true
  # validates :address, presence: true
end
