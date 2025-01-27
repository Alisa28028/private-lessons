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
  validates :price_cents, presence: true
  validates :capacity, presence: true
  validates :duration, presence: true
  validates :day_of_week, inclusion: {
    in: %w[Sunday Monday Tuesday Wednesday Thursday Friday Saturday],
    message: "%{value} is not a valid day of the week"
  }, if: :recurring_weekly?
  # validates :date, presence:true
   # validates :location, presence: { message: "must be selected or entered" }
  # validates :start_time, presence: true
  # validates :end_time, presence: true
  # validates :start_date, presence: true
  # validates :end_date, presence: true

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
      instance.end_time = start_datetime + (self.duration || 0).minutes
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

  # Method for handling weekly events
  # def generate_weekly_instances(start_date, end_date, day_of_week, start_time)
  #   Rails.logger.debug "Generating weekly instances with: start_date=#{start_date}, end_date=#{end_date}, day_of_week=#{day_of_week}, start_time=#{start_time}"

  #     # Default start_time to a specific value if blank (e.g., 9:00 AM)
  # start_time ||= "09:00"

  #   target_wday = Date::DAYNAMES.index(day_of_week)
  #   Rails.logger.debug "Target weekday index: #{target_wday}"

  #   dates = (start_date..end_date).to_a.select { |date| date.wday == target_wday }
  #   Rails.logger.debug "Selected dates: #{dates}"

  #   dates.each do |date|
  #     instance = event_instances.new(date: date, start_time: start_time)
  #     if instance.save
  #       Rails.logger.debug "Created instance: #{instance.inspect}"
  #     else
  #       Rails.logger.error "Failed to create instance: #{instance.errors.full_messages}"
  #     end
  #   end
  # end

  def generate_instances!
    start_date = self.start_date.to_date
    end_date = self.end_date.to_date
    return unless start_date && end_date && day_of_week

    # Convert the day of the week (e.g., "Tuesday") into an integer (0 = Sunday, 1 = Monday, etc.)
    day_of_week_index = Date::DAYNAMES.index(day_of_week)

    # Debug log to check inputs
    Rails.logger.debug { "Start date: #{start_date}, End date: #{end_date}, Day of week: #{day_of_week} (index: #{day_of_week_index})" }

    # Collect matching dates for the specified day of the week
    matching_dates = (start_date..end_date).select { |date| date.wday == day_of_week_index }

    # Debug log to check the generated dates
    Rails.logger.debug { "Matching dates for instances: #{matching_dates.inspect}" }

    # Iterate over the matching dates and create instances
    matching_dates.each do |date|
      event_instances.create!(date: date, start_time: start_time)
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

private
def recurring_weekly?
  recurrence_type == "every-week"
end

end
