class EventsController < ApplicationController

  before_action :set_event, only: [:edit, :show, :update, :add_video]

  def index
    @user = current_user
    @users = User.all

    @event_instances = EventInstance.where("date > ?", Time.now).order(:date)

    # Get associated events for the sorted event instances
    @events = @event_instances.map(&:event).uniq


    @event_bookings = Booking.where(event_instance_id: @event_instances.pluck(:id))

    # Get bookings for the current user
    @bookings = @user.bookings
  end

  def new
    @event = Event.new
    @event.event_instances.build

    # @locations = Location.all.map(&:name)
    # if params[:start_time].present? && params[:end_time].present?
    #   @studiolist = StudioFetcher.fetch_studiolist(params[:start_time], params[:end_time])
    #   @studiolist ||= []
    #   respond_to do |format|
    #     format.json { render partial: "events/locations", locals: { studiolist: @studiolist }, formats: [:html]}
    #   end
    # end
  end

  def attendees
    @attendees = Event.find(params[:id]).users
  end

  def show
    # @user = User.find(params[:id])

    # @event = @user.events
    # @upcoming_events = @events.select { |event| event.start_date >= Date.today}.sort_by(&:start_date)
    # @past_events = @events.select { |event| event.start_date < Date.today}.sort_by(&:start_date).reverse
    if @events.present?
    @upcoming_events = @events.where("start_date >= ?", Date.today).order(start_date: :asc)
    @past_events = @events.where("start_date < ?", Date.today).order(start_date: :desc)
    else @upcoming_events = []
      @past_events = []

    end
    # Set default time zone to JST (Asia/Tokyo)
    jst_time_zone = 'Asia/Tokyo'

      # Convert event times to the current user's time zone, if available, otherwise use JST
    if current_user && current_user.time_zone
      @event.start_time = @event.start_time&.in_time_zone(current_user.time_zone)
      @event.end_time = @event.end_time&.in_time_zone(current_user.time_zone)

      @event.event_instances.each do |instance|
        instance.start_time = instance.start_time&.in_time_zone(current_user.time_zone)
        instance.end_time = instance.end_time&.in_time_zone(current_user.time_zone)
      end
    else
      jst_time_zone = "Asia/Tokyo"
      @event.start_time = @event.start_time&.in_time_zone(jst_time_zone)
      @event.end_time = @event.end_time&.in_time_zone(jst_time_zone)

      @event.event_instances.each do |instance|
        instance.start_time = instance.start_time&.in_time_zone(jst_time_zone)
        instance.end_time = instance.end_time&.in_time_zone(jst_time_zone)
      end
    end

    # Fetch bookings for the event
    @bookings = Booking.where(event_id: @event) # bookings list for this event
    @new_booking = Booking.new # instance to allow new booking
  end

  # def create
  #   @event = Event.new(event_params)
  #   @location = Location.find_by(name: params[:location_name])
  #   @location ||= Location.create(name: params[:location_name])
  #   @event.location = @location

  #   @event.user = current_user
  #     if @event.save
  #       redirect_to root_path #need to change this to dashboard
  #     else
  #       render 'new', status: :unprocessable_entity
  #     end
  # end


  def create
    # Initialize the event object
    @event = Event.new(event_params)

    # Log the parameters for debugging
  Rails.logger.debug "Capacity: #{params[:event][:capacity]}"
  Rails.logger.debug "Duration: #{params[:event][:duration]}"

  # Set default values for capacity and duration if blank
  @event.capacity = 10 if @event.capacity.blank?
  @event.duration = 60 if @event.duration.blank?

  Rails.logger.debug "Event params: #{event_params.inspect}"
  Rails.logger.debug "Event object: #{@event.inspect}"
  Rails.logger.debug "Recurrence type: #{@event.recurrence_type}"

    # Handle the location - find by name, or create a new one if it doesn't exist
    # @location = Location.find_by(name: params[:location_name])
    # @location ||= Location.create(name: params[:location_name])
    # @event.location = @location

    # Associate the current user with the event
    @event.user = current_user
    if @event.save

    # Handle one-time event logic
    if params[:event][:event_instances_attributes].present? && params[:event][:event_instances_attributes]["0"][:start_time].present?
      if @event.recurrence_type == 'one-time'
      @event.handle_one_time_event(params)
      end
    end

    # Handle custom dates logic
    if params[:event][:custom_dates].present?
      Rails.logger.debug "Received custom dates: #{params[:event][:custom_dates].inspect}"
      @event.handle_custom_dates_event(params[:event][:custom_dates])
    end


      # Generate weekly event instances if recurrence is weekly
      if @event.recurrence_type == 'every-week'
        @event.generate_instances!
      end

      redirect_to dashboard_path, notice: "Event and instances were successfully created."
    else
      Rails.logger.debug @event.errors.full_messages # Log errors for debugging
      render :new, status: :unprocessable_entity
    end
  end


  def add_video
    if params[:event][:videos].present?
      params[:event][:videos].each do |file|
        @event.videos.attach(file)
      end
    end
    if @event.save
      redirect_to @event, notice: 'Video(s) successfully added.'
    else
      flash.now[:alert] = "There was an error adding the videos"
      render :edit
    end
  end

  def destroy
    @event = Event.find(params[:id])
    @event.destroy

    if request.referer.include?('/users')
      redirect_to user_path(current_user, anchor: 'classes'), notice: "Event successfully deleted!"
    else
      redirect_to events_path, notice: "Event successfully deleted!"
    end
  end

  def edit
    @event = Event.find(params[:id])
    @locations = Location.all.map(&:name)
    if params[:start_time].present? && params[:end_time].present?
      @studiolist = StudioFetcher.fetch_studiolist(params[:start_time], params[:end_time])
      @studiolist ||= []
      respond_to do |format|
        format.json { render partial: "events/locations", locals: { studiolist: @studiolist }, formats: [:html]}
      end
    end
  end

  def update
    @event = Event.find(params[:id])
    @location = Location.find_by(name: params[:location_name])
    @location ||= Location.create(name: params[:location_name]) if params[:location_name].present?
    if @location
    @event.location = @location
    else
      flash.now[:alert] = "Please provide location."
      render 'edit', status: :unprocessable_entity and return
    end

    if @event.update(event_params)
      redirect_to event_path(@event)
    else
      render 'edit', status: :unprocessable_entity
    end
  end

  def duplicate
    @event = Event.find(params[:id])
    @new_event = @event.dup
    @new_event.user = current_user  # Make the current user the creator of the new event

    if @new_event.save
      redirect_to edit_event_path(@new_event, duplicate: true), notice: "Event successfully duplicated!"
    else
      redirect_to events_path, alert: "Failed to duplicate the event."
    end
  end

  def search
    if params[:query].present?
      @events = Event.search_by_title_and_description_and_user(params[:query])
    else
      @events = []
    end
  end

  def end_time
    (start_time + duration.minutes).strftime("%H:%M")
  end

  private

  def set_event
    @event = Event.find(params[:id])
  end



  def event_params
    params.require(:event).permit(:title, :description, :capacity, :duration, :recurrence_type, :custom_dates, :start_date, :end_date, :start_time, :price_cents, :day_of_week, videos: [], photos: [],
      event_instances_attributes: [:id, :date, :start_time, :_destroy]
    )
  end
end
