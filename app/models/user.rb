class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # validates :name, presence: true
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :email, presence: true, uniqueness: { case_sensitive: false }
  validates :password, presence: true, confirmation: true, length: { minimum: 6 }, on: :create
  validates :phone_number, presence: true, on: :create
  validates :time_zone, presence: true,
                      inclusion: { in: ActiveSupport::TimeZone.all.map(&:name) }
  validates :tiktok, :x, :instagram, length: { maximum: 255 }, allow_nil: true
  validates :username,
  uniqueness: true,
  allow_nil: true,
  format: { with: /\A[a-zA-Z0-9_]+\z/, message: "only allows letters, numbers, and underscores" }

  has_many :events, dependent: :destroy
  has_many :event_instances, through: :events
  has_many :bookings, dependent: :destroy
  has_many :bookings_as_teacher, through: :events, source: :bookings
  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :videos, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :weekly_availabilities, dependent: :destroy
  accepts_nested_attributes_for :weekly_availabilities, allow_destroy: true

  has_many :liked_event_instances, through: :likes, source: :event_instance
  has_and_belongs_to_many :locations, join_table: 'locations_users'

  has_one_attached :photo

  def is_teacher?
    events.any?
  end

  def is_teacher_for?(event)
    event.user_id == self.id
  end

end
