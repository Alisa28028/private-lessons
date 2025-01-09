class EventsController < ApplicationController

  before_action :set_event, only: [:edit, :show, :update, :add_video]

  def index
    @user = current_user
    @users = User.all

    @events = Event.all

    # Make sure @event_bookings only gets assigned if @events is not empty
    if @events.present?
      @event_bookings = Booking.where(event_id: @events.pluck(:id))
    else
      @event_bookings = []
    end

    @bookings = @user.bookings
  end

  def new
    @event = Event.new
    @locations = Location.all.map(&:name)
    if params[:start_time].present? && params[:end_time].present?
      @studiolist = StudioFetcher.fetch_studiolist(params[:start_time], params[:end_time])
      @studiolist ||= []
      respond_to do |format|
        format.json { render partial: "events/locations", locals: { studiolist: @studiolist }, formats: [:html]}
      end
    end
  end

  def attendees
    @attendees = Event.find(params[:id]).users
  end

  def show
    @user = current_user # teacher user organizing this event (= teacher)
    # @event = Event.find(params[:id]) # event I identify through show url id
    @bookings = Booking.where(event_id: @event) # bookings list for this event
    @new_booking = Booking.new # instance to allow new booking
  end

  def create
    @event = Event.new(event_params)
    @location = Location.find_by(name: params[:location_name])
    @location ||= Location.create(name: params[:location_name])
    @event.location = @location

    @event.user = current_user
      if @event.save
        redirect_to root_path #need to change this to dashboard
      else
        render 'new', status: :unprocessable_entity
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
    redirect_to events_path, status: :see_other
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

  private

  def set_event
    @event = Event.find(params[:id])
  end

  def event_params
    params.require(:event).permit(:title, :capacity, :price_cents, :location_id, :start_date, :end_date, :description, videos: [], photos: [])
  end
end
