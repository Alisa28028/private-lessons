class BookingsController < ApplicationController

  # def index
  #   @event = Event.find(params[:event_id])
  #   @bookings = Booking.where(event_id: @event) # bookings list for this event
  # end
  def create
    Rails.logger.debug "Event Instance ID: #{params[:event_instance_id]}"

    @event_instance = EventInstance.find(params[:event_instance_id])
    # @booking = @event_instance.bookings.build(user: current_user)
    # @booking = Booking.create!(event: @event, user: current_user, state: 'paid')
    if @event_instance.effective_capacity - @event_instance.bookings.count > 0
      # There is space → Proceed with normal booking
      @booking = @event_instance.bookings.new(user: current_user, waitlisted: false)
    else
      # No space → Add to waitlist
      @booking = @event_instance.bookings.new(user: current_user, waitlisted: true, joined_at: Time.current)
    end

    if @booking.save
      if @booking.waitlisted == false
      # send the email
    BookingMailer.booking_confirmation(current_user, @booking).deliver_now
      end

      notice_message = @booking.waitlisted? ? "You've been added to the waitlist!" : "You are booked!"
      flash[:notice] = notice_message
      redirect_to event_instances_path, notice: notice_message
    else
      Rails.logger.debug "Booking Errors: #{@booking.errors.full_messages.join(", ")}"
    flash[:alert] = "Booking failed: #{@booking.errors.full_messages.join(", ")}"
      redirect_back fallback_location: event_instances_path, alert: 'There was an error with your booking. Please try again.'
    end
  end

# def join_waitlist
#   @event_instance = EventInstance.find(params[:event_instance_id])
#   @booking = @event_instance.bookings.find_or_initialize_by(user: current_user)

#   if @event_instance.effective_capacity - @event_instance.bookings.count > 0
#     # If there is space, book them normally
#     @booking.update(waitlisted: false, joined_at: nil)
#     flash[:notice] = "You are booked!"
#   else
#     # If no space, add to the waitlist
#     @booking.update(waitlisted: true, joined_at: Time.current)
#     flash[:notice] = "You have been added to the waitlist!"
#   end

#   redirect_to event_instance_path(@event_instance)
# end

# def leave_waitlist
#   @event_instance = EventInstance.find(params[:event_instance_id])
#   @booking = @event_instance.bookings.find_by(user: current_user, waitlisted: true)

#   if @booking
#     @booking.update(waitlisted: false, joined_at: nil)
#     flash[:notice] = "You have successfully left the waitlist."
#   end

#   redirect_to event_instance_path(@event_instance)
# end


  def destroy
    @booking = Booking.find_by(id: params[:id])

    if @booking.nil?
      flash[:alert] = "Booking not found."
      redirect_back(fallback_location: root_path) and return
    end
    if @booking.waitlisted? || booking.user == current_user
      @booking.destroy
      flash[:notice] = "You have been removed from the waitlist."
    else
      flash[:alert] = "You can't remove this booking."
    end
    redirect_to event_instance_path(@booking.event_instance)

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
