class EventsController < ApplicationController

  before_action :set_event, only: [:edit, :show, :update, :add_video]

  def index
    @user = current_user
    @users = User.all
    @events = Event.all

    # @event_bookings = Booking.where(event_id: @events)
    @event_bookings = Booking.where(event_id: @events.pluck(:id))
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
      @event.start_time = @event.start_time.in_time_zone(current_user.time_zone)
      @event.end_time = @event.end_time.in_time_zone(current_user.time_zone)
    else
      @event.start_time = @event.start_time.in_time_zone(jst_time_zone)
      @event.end_time = @event.end_time.in_time_zone(jst_time_zone)
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

    # Handle the location - find by name, or create a new one if it doesn't exist
    # @location = Location.find_by(name: params[:location_name])
    # @location ||= Location.create(name: params[:location_name])
    # @event.location = @location

    # Associate the current user with the event
    @event.user = current_user

    # Handle one-time event logic
    if params[:event][:event_instances_attributes].present? && params[:event][:event_instances_attributes]["0"][:start_time].present?
      @event.handle_one_time_event(params)
    end

    # Handle custom dates logic
    if params[:event][:custom_dates].present?
      @event.handle_custom_dates_event(params[:event][:custom_dates])
    end

        # Handle weekly recurrence logic
      if params[:event][:recurrence_type] == "weekly" &&
        params[:event][:start_date].present? &&
        params[:event][:end_date].present? &&
        params[:event][:day_of_week].present? &&
        params[:event][:start_time].present?

      start_date = params[:event][:start_date].to_date
      end_date = params[:event][:end_date].to_date
      day_of_week = params[:event][:day_of_week]
      start_time = params[:event][:start_time]

      # Generate weekly event instances
      @event.generate_weekly_instances(start_date, end_date, day_of_week, start_time)
    end

    # Save the event and handle success/failure
    if @event.save
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
    params.require(:event).permit(:title, :capacity, :duration, :recurrence_type, :custom_dates, :price_cents, :description, videos: [], photos: [], event_instances_attributes: [:date, :start_time, :end_time])
  end
end
