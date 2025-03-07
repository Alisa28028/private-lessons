class PaymentsController < ApplicationController
  def new
    @booking = current_user.bookings.where(state: "pending").find(params[:booking_id])
    @event_instance = EventInstance.find(@booking.event_instance.id)
  end

  def fake
    @event_instance = EventInstance.find(params[:event_instance_id])
    @new_booking = Booking.new # instance to allow new booking
  end
end
