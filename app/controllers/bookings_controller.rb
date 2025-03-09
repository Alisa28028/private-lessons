class BookingsController < ApplicationController

  # def index
  #   @event = Event.find(params[:event_id])
  #   @bookings = Booking.where(event_id: @event) # bookings list for this event
  # end
  def create
    Rails.logger.debug "Event Instance ID: #{params[:event_instance_id]}"

    @event_instance = EventInstance.find(params[:event_instance_id])
    @booking = @event_instance.bookings.build(user: current_user)
    # @booking = Booking.create!(event: @event, user: current_user, state: 'paid')

    if @booking.save
      # send the email
    BookingMailer.booking_confirmation(current_user, @booking).deliver_now

      flash[:notice] = "You have successfully booked this class!"
      redirect_to event_instances_path, notice: 'Your booking was successful! A confirmation email has been sent.'
    else
      Rails.logger.debug "Booking Errors: #{@booking.errors.full_messages.join(", ")}"
    flash[:alert] = "Booking failed: #{@booking.errors.full_messages.join(", ")}"
      redirect_back fallback_location: event_instances_path, alert: 'There was an error with your booking. Please try again.'
    end
  end

  #   # Redirect to the event show page with a success message
  #   redirect_to event_path(@event), notice: 'Your booking was successful! A confirmation email has been sent.'
  # rescue ActiveRecord::RecordInvalid => e
  #   # Handle any errors (e.g., invalid booking data)
  #   redirect_to event_path(@event), alert: 'There was an error with your booking. Please try again.'
  # end

    # -----STRIPE REMOVED FOR DEMO PURPOSES-----
    # ------------------------------------------
    # price = Stripe::Price.create({
    #   unit_amount: @event.price_cents,
    #   currency: 'jpy',
    #   product_data: {
    #     name: @event.title
    #   }
    # })

    # session = Stripe::Checkout::Session.create(
    #   payment_method_types: ['card'],
    #   line_items: [{
    #     price: price.id,
    #     quantity: 1
    #   }],
    #   mode: 'payment',
    #   success_url: event_url(@event), # Expectation that these two aren't correct
    #   cancel_url: event_url(@event)   # This one too
    # )

    # @booking.update(checkout_session_id: session.id)
    # redirect_to new_booking_payment_path(@booking)
    # ------------------------------------------
    # -----STRIPE REMOVED FOR DEMO PURPOSES-----
    private

    def booking_params
      params.require(:booking).permit(:user_id) # Add any other required fields
    end
end
