class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :name, presence: true
  validates :email, presence: true, uniqueness: { case_sensitive: false }
  validates :password, presence: true, confirmation: true, length: { minimum: 6 }
  validates :phone_number, presence: true
  has_many :events, dependent: :destroy
  has_many :bookings, dependent: :destroy
  has_many :bookings_as_teacher, through: :events, source: :bookings
  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy
  def is_teacher?
    events.any?
  end
  has_one_attached :photo
end
