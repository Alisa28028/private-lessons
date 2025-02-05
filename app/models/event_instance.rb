class EventInstance < ApplicationRecord
  belongs_to :event
  has_many :bookings
  validates :date, presence: true
  validates :start_time, presence: true
  has_many :videos, dependent: :destroy

  # validates :capacity
  # validates :price
  # validates :duration
  before_save :set_end_time_from_duration

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
     # Ensure custom_dates is a string, then split it by commas to get an array
    custom_dates = custom_dates.split(',') if custom_dates.is_a?(String)

    custom_dates.each do |custom_date|
      begin
        # Parse the date string
        parsed_date = Date.parse(custom_date)

        # Create an event instance for each date
        self.event_instances.create!(
          start_time: parsed_date.to_time, # Assuming the event starts at midnight, or adjust as needed
          end_time: parsed_date.to_time + self.duration.minutes, # Duration-based end time
          date: parsed_date # Store the date for reference
        )
      rescue ArgumentError
        self.errors.add(:custom_dates, "#{custom_date} is not a valid date.")
      end
    end
  end

  def spots_left
    capacity - bookings.count
  end

  private

  def recurring_weekly?
    recurrence_type == "every-week"
  end

  def set_end_time_from_duration
    return if start_time.nil? || event.duration.nil?
    self.end_time = start_time + event.duration.minutes
  end

end
