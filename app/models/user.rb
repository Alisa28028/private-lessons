class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :name, presence: true
  validates :email, presence: true, uniqueness: { case_sensitive: false }
  validates :password, presence: true, confirmation: true, length: { minimum: 6 }, on: :create
  validates :phone_number, presence: true, on: :create
  validates_inclusion_of :time_zone, in: ActiveSupport::TimeZone.all.map(&:name), allow_nil: true
  validates :tiktok, :x, :instagram, length: { maximum: 255 }, allow_nil: true

  has_many :events, dependent: :destroy
  has_many :event_instances, through: :events
  has_many :bookings, dependent: :destroy
  has_many :bookings_as_teacher, through: :events, source: :bookings
  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :videos, dependent: :destroy
  has_and_belongs_to_many :locations

  has_one_attached :photo

  def is_teacher?
    events.any?
  end
end
