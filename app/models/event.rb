class Event < ApplicationRecord
  belongs_to :user
  belongs_to :location, optional: true

  has_many :bookings, dependent: :destroy
  has_many :users, through: :bookings
  has_many :bookings, dependent: :destroy
  has_many :posts, dependent: :destroy
  has_many :event_instances, dependent: :destroy
  has_many :attendees, through: :bookings, source: :user
  has_many_attached :photos
  has_many_attached :videos

  validates :title, presence: true
  # validates :start_date, presence: true
  # validates :end_date, presence: true
  validates :price_cents, presence: true
  validates :capacity, presence: true
  # validates :location, presence: { message: "must be selected or entered" }
  # validates :start_time, presence: true
  # validates :end_time, presence: true
  validates :duration, presence: true
  # validates :date, presence:true

  accepts_nested_attributes_for :event_instances, allow_destroy: true

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

  def handle_one_time_event(params)
    # Find or initialize the first EventInstance
    instance = self.event_instances.first_or_initialize

    # Extract user inputs for date and time
    event_attributes = params[:event][:event_instances_attributes]["0"]
    user_date = event_attributes[:date]
    start_time_string = event_attributes[:start_time]

    if user_date.present? && start_time_string.present?
      # Parse the user's date
      parsed_date = Date.parse(user_date)

      # Parse the user's time (e.g., "14:00") into a Time object
      parsed_time = Time.strptime(start_time_string, "%H:%M")

      # Combine the date and time into a DateTime object
      start_datetime = parsed_date.to_time.change(hour: parsed_time.hour, min: parsed_time.min)

      # Assign the attributes to the instance
      instance.start_time = start_datetime
      instance.end_time = start_datetime + self.duration.minutes
      instance.date = parsed_date

      if instance.save
        Rails.logger.info("Event instance saved successfully with start_time: #{instance.start_time}")
      else
        Rails.logger.error("Failed to save event instance: #{instance.errors.full_messages}")
      end
    else
      self.errors.add(:base, "Start time and date are required for a one-time event.")
    end
  end

  # Method for handling custom dates
  def handle_custom_dates_event(custom_dates)
    custom_dates = custom_dates || [] # Ensure custom_dates is an array
    custom_dates.each do |custom_date|
      begin
        parsed_date = DateTime.parse(custom_date)
        self.event_instances.build(
          start_time: parsed_date,
          end_time: parsed_date + self.duration.minutes,
          date: parsed_date.to_date
        )
      rescue ArgumentError
        self.errors.add(:custom_dates, "#{custom_date} is not a valid date.")
      end
    end
  end

end
