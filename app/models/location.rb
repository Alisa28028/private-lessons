class Location < ApplicationRecord
  has_and_belongs_to_many :users, join_table: 'locations_users'
  validates :name, presence: true, uniqueness: true

  has_many :events
  has_many :event_instances
  # validates :address, presence: true
end
