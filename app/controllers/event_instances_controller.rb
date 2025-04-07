class EventInstancesController < ApplicationController
  before_action :set_event_instance, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy]


  def new
    @event_instance = EventInstance.new
    @event = Event.find(params[:event_id])
    @event_photos = @event.photos
  end

  def home

  end

  def create
    @event_instance = EventInstance.new(event_instance_params)
    @event = Event.find(params[:event_id])
    @event_instance.event = @event

    # if params[:add_new_location] == 'true' && params[:event_instance][:new_location_name].present?
    #   # Create a new location if the user entered a new location name
    #   new_location = Location.create(name: params[:event_instance][:new_location_name])
    #   @event_instance.location = new_location
    # else
    #   # Assign an existing location if selected
    #   @event_instance.location_id = params[:event_instance][:location_id]
    # end

    if @event_instance.save
      redirect_to event_path(@event), notice: "Event(s) successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @event = @event_instance.event
    @new_booking = Booking.new
    @bookings = @event_instance.bookings
  end

  def edit
    @event_instance = EventInstance.find(params[:id])
    @event = @event_instance.event
    @event_instance.start_time = @event_instance.start_time.in_time_zone('Asia/Tokyo') if @event_instance.start_time.present?
    # Set the location_name to the name of the associated location
    @event_instance.location_name = @event_instance.location&.name

  end

  # def update
  #   if @event_instance.update(event_instance_params)
  #     redirect_to event_path(@event_instance.event), notice: "Event sucessfully updated."
  #   else
  #     render :edit, status: :unprocessable_entity
  #   end
  # end

  def update
    Rails.logger.debug "Incoming parameters: #{params.inspect}"

    @event_instance = EventInstance.find(params[:id])
    @event = @event_instance.event # Fetch the associated event

    # Check if location was provided, either via location_id or location_name
  if params[:event_instance][:location_id].present?
    @event_instance.location = Location.find(params[:event_instance][:location_id])
    Rails.logger.debug "Using existing location with ID: #{@event_instance.location.inspect}"
  elsif params[:event_instance][:location_name].present?
    # If a new location name was provided, find or create the location and associate it
    location = Location.find_or_create_by(name: params[:event_instance][:location_name])
    @event_instance.location = location
     Rails.logger.debug "New location created with name: #{location.inspect}"
  end

    # Handle photo upload, ensuring that new photos are added to existing ones
    if params[:event_instance][:photos].present?
      # Append new photos to existing ones
      @event_instance.photos.attach(params[:event_instance][:photos])
    end


    # Begin a transaction to ensure both the EventInstance and Event are updated together
    ActiveRecord::Base.transaction do
      # Handle the start_time conversion if it's being updated
      if params[:event_instance][:start_time].present?
        # Convert the start_time to Asia/Tokyo time if necessary
        @event_instance.start_time = params[:event_instance][:start_time].in_time_zone('Asia/Tokyo')
      end

      # Update the EventInstance with the new parameters
      if @event_instance.update(event_instance_params)
        Rails.logger.debug "EventInstance after update: #{@event_instance.inspect}"

        # Only update the event's attributes if the event_instance is updated successfully
        if @event.update(event_instance_params[:event_attributes])
          # Redirect to the event instance page if both are successful
          redirect_to @event_instance, notice: 'Event instance successfully updated.'
        else
          render :edit, alert: 'Failed to update event.'
        end
      else
        render :edit, alert: 'Failed to update event instance.'
      end
    end


  def destroy
    @event_instance = EventInstance.find_by(id: params[:id])
      if @event_instance
        @event_instance.destroy
        notice_message = "Event successfully deleted!!!"
      else
        notice_message = "Event not found."
      end


    # Redirect logic based on the referer
    referer = request.referer

    if referer&.include?('/users')
      redirect_to user_path(current_user, anchor: 'classes'), notice: notice_message
    elsif referer&.include?(root_path) # Redirect to homepage if deleted from homepage
      redirect_to root_path, notice: notice_message
    elsif referer&.include?('/dashboard') # Redirect to dashboard if deleted from dashboard
      redirect_to dashboard_path, notice: notice_message
    elsif event.present?
      redirect_to event_path(event), notice: notice_message
    else
      redirect_to root_path, notice: notice_message # Fallback in case event was nil
    end
  end
end


  private

  def set_event_instance
    @event_instance = EventInstance.find(params[:id])
    @event_instance.event ||= Event.new
  end

  def event_instance_params
    params.require(:event_instance).permit(
      :start_time, :end_time, :start_date, :end_date, :duration, :capacity, :price, :cancellation_policy_duration,
      :location_id, :location_name,
      photos: [],
      videos: [],
      event_attributes: [:id, :title, :description, :location_id, :location_name] # Permit event attributes here
    )
  end


  # def event_params
  #   params.require(:event_instance).permit(
  #     event_attributes: [:id, :title, :description, :location_id, :location_name]  # Permit location_id and location_name here too if updating Event attributes
  #   )[:event_attributes]  # Extract the `event_attributes` hash from the params
  # end
end
