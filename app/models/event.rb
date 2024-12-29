class Event < ApplicationRecord
  belongs_to :user
  belongs_to :location

  has_many :bookings, dependent: :destroy
  has_many :users, through: :bookings
  has_many :bookings, dependent: :destroy
  has_many :posts, dependent: :destroy
  has_many_attached :photos
  has_many_attached :videos

  validates :title, presence: true
  validates :start_date, presence: true
  validates :end_date, presence: true
  validates :price_cents, presence: true
  validates :capacity, presence: true
  validates :location, presence: { message: "must be selected or entered" }

  include PgSearch::Model
  pg_search_scope :search_by_title_and_description_and_user,
  against: [ :title, :description ],
  associated_against: {
    user: [ :name ]
  },
  using: {
    tsearch: { prefix: true }
  }

  monetize :price_cents

end
