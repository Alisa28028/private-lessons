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
    @event.event_instances.build if @event.event_instances.empty?

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

    # if @events.present?
    # @upcoming_events = @events.where("start_date >= ?", Date.today).order(start_date: :asc)
    # @past_events = @events.where("start_date < ?", Date.today).order(start_date: :desc)
    # else @upcoming_events = []
    #   @past_events = []

    # end
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
    @event.capacity = params[:event][:capacity].present? ? params[:event][:capacity] : @event.default_capacity

    # Handle the location - find by name, or create a new one if it doesn't exist
    # @location = Location.find_by(name: params[:location_name])
    # @location ||= Location.create(name: params[:location_name])
    # @event.location = @location

    # Associate the current user with the event
    @event.user = current_user
    if @event.save
      handle_event_instances_creation
      redirect_to dashboard_path, notice: "Event(s) were sucessfully created."
    else
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
    if @event
      @event.destroy
      notice_message = "Event successfully deleted"
    else
      notice_message = "Event not found."
    end

      # Redirect logic based on the referer
    referer = request.referer

    if referer&.include?('/users')
      redirect_to user_path(current_user, anchor: 'classes'), notice: notice_message
    elsif referer&.include?('/dashboard') # Redirect to dashboard if deleted from dashboard
      redirect_to dashboard_path, notice: notice_message
    elsif referer&.include?(root_path) # Redirect to homepage if deleted from homepage
      redirect_to root_path, notice: notice_message
    elsif event.present?
      redirect_to event_path(event), notice: notice_message
    else
      redirect_to root_path, notice: notice_message # Fallback in case event was nil
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
    @event = Event.find_by(id: params[:id])
    # if ID belongs to an  EventInstance, find its associated Event
    if @event.nil?
      event_instance = EventInstance.find_by(id: params[:id])
      @event = event_instance&.event
    end

    unless @event
      redirect_to events_path, alert: "Event not found."
    end
  end

  def event_params
    params.require(:event).permit(:title, :description, :capacity, :cancellation_policy_duration, :default_capacity, :duration, :recurrence_type, :custom_dates, :start_date,
       :end_date, :start_time, :price_cents, :day_of_week, videos: [], photos: [],
      event_instances_attributes: [:id, :date, :start_time, :capacity , :cancellation_policy_duration, :_destroy]
    )
  end

  def handle_event_instances_creation
   # Handle one-time event logic
    if params[:event][:event_instances_attributes].present? && params[:event][:event_instances_attributes]["0"][:start_time].present?
      Rails.logger.debug "💾 Event saved: #{@event.inspect}"

      if @event.recurrence_type == 'one-time'
      @event.handle_one_time_event(params)
      end
    end

    # Handle custom dates logic
    if params[:event][:custom_dates].present?
      Rails.logger.debug "🗓️Received custom dates: #{params[:event][:custom_dates].inspect}"
      Rails.logger.debug "🛠 Params received in controller: #{params.inspect}"

      @event.update!(start_time: params[:event][:start_time]) # Ensure start_time is set

      @event.reload
      @event.handle_custom_dates_event(params[:event][:custom_dates])
    end

    # Generate weekly event instances if recurrence is weekly
    if @event.recurrence_type == 'every-week'
      @event.generate_instances!
    end

    @event.event_instances.each do |instance|
      instance.update!(
        capacity: @event.capacity || @event.default_capacity,
        price: instance.price.presence || @event.price || 0
      )
    end
  end
end
