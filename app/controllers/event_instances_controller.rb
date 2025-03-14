class EventInstancesController < ApplicationController
  before_action :set_event_instance, only: [:show, :edit, :update, :destroy]

  def new
    @event_instance = EventInstance.new
    @event = Event.find(params[:event_id])
  end

  def create
    @event_instance = EventInstance.new(event_instance_params)
    @event = Event.find(params[:event_id])
    @event_instance.event = @event

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
    @event = @event_instance.event
  end

  def update
    if @event_instance.update(event_instance_params)
      redirect_to event_path(@event_instance.event), notice: "Event sucessfully updated."
    else
      render :edit,  status: :unprocessable_entity
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


  private

  def set_event_instance
    @event_instance = EventInstance.find(params[:id])
  end

  def event_instance_params
    params.require(:event_instance).permit(:date, :start_time, :end_time, :capacity, :duration, :price, :cancellation_policy_duration)
  end
end
