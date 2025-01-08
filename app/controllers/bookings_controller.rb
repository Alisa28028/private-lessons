class BookingsController < ApplicationController

  # def index
  #   @event = Event.find(params[:event_id])
  #   @bookings = Booking.where(event_id: @event) # bookings list for this event
  # end
  def create
    @event = Event.find(params[:event_id])
    @booking = Booking.create!(event: @event, user: current_user, state: 'paid')

    # send the email
    BookingMailer.booking_confirmation(current_user, @booking).deliver_now

    # Redirect to the event show page with a success message
    redirect_to event_path(@event), notice: 'Your booking was successful! A confirmation email has been sent.'
  rescue ActiveRecord::RecordInvalid => e
    # Handle any errors (e.g., invalid booking data)
    redirect_to event_path(@event), alert: 'There was an error with your booking. Please try again.'
  end

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
end
