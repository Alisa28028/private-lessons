class Post < ApplicationRecord
  belongs_to :user

  has_rich_text :content
  has_many :comments, dependent: :destroy
  has_many_attached :photos
  has_many_attached :videos
  belongs_to :event, optional: true
  belongs_to :event_instance, optional: true
  # validates :content, presence: true
  validates :title, presence: true
  validates :user, presence: true
  validates :videos, presence: true, if: :is_video

  attr_accessor :is_video
end
