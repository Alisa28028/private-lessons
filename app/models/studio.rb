class Studio < ApplicationRecord
  has_one_attached :icon
  has_many :weekly_availabilities
end
