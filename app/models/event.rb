class Event < ApplicationRecord
  belongs_to :user
  belongs_to :location

  has_many :bookings, dependent: :destroy
  has_many :users, through: :bookings
  has_many :bookings, dependent: :destroy
  has_many :posts, dependent: :destroy
  has_many :attendees, through: :bookings, source: :user
  has_many :event_instances, dependent: :destroy
  has_many_attached :photos
  has_many_attached :videos

  validates :title, presence: true
  validates :start_date, presence: true
  validates :end_date, presence: true
  validates :start_time, presence: true
  validates :end_time, presence: true
  validates :date, presence: true
  validates :duration, presence: true
  validates :price_cents, presence: true
  validates :capacity, presence: true
  validates :location, presence: { message: "must be selected or entered" }
  validates :recurrence_type, inclusion: { in: ['None', 'Daily', 'Weekly', 'Custom'], message: "%{value} is not a valid recurrence type" }, allow_nil: true

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

   # Create recurring instances based on selected pattern
   def create_event_instances
    recurrence_type = self.recurrence_type  # e.g., weekly
    recurrence_details = self.recurrence_details  # e.g., number of occurrences or specific dates

    case recurrence_type
    when 'Weekly'
      (0..4).each do |week_offset|  # For example, create 5 weekly occurrences
        start_time = self.start_date + (week_offset * 7).days
        end_time = start_time + (self.end_date - self.start_date)
        self.event_instances.create!(start_time: start_time, end_time: end_time)
      end
    when 'Custom'
      # If the recurrence details are specific dates
      custom_dates = recurrence_details.split(',')  # e.g., "2023-07-01,2023-07-08"
      custom_dates.each do |date|
        start_time = Date.parse(date) + self.start_date.seconds_since_midnight.seconds
        end_time = start_time + (self.end_date - self.start_date)
        self.event_instances.create!(start_time: start_time, end_time: end_time)
      end
    end
  end

end
