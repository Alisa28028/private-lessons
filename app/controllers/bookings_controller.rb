class BookingsController < ApplicationController
  before_action :authenticate_user!

  # def index
  #   @event = Event.find(params[:event_id])
  #   @bookings = Booking.where(event_id: @event) # bookings list for this event
  # end
  def create
    @event_instance = EventInstance.find(params[:event_instance_id])

    # Check if the user already has a booking (either confirmed or waitlisted)
    existing_booking = @event_instance.bookings.find_by(user: current_user)

    if existing_booking
      flash[:alert] = existing_booking.waitlisted? ? "You are already on the waitlist for this class." : "You have already booked this class."
      redirect_back fallback_location: event_instance_path(@event_instance) and return
    end

    # Determine if the booking should be waitlisted
    is_waitlisted = @event_instance.effective_capacity <= @event_instance.bookings.where(waitlisted: false).count

    # Determine status
    status = if is_waitlisted
                "pending"  # still needs approval to be confirmed
            elsif @event_instance.approval_mode == "manual"
                "pending"
            else
                "confirmed"
            end

    @booking = @event_instance.bookings.new(
      user: current_user,
      waitlisted: is_waitlisted,
      joined_at: is_waitlisted ? Time.current : nil,
      status: status
    )



    if @booking.save
      BookingMailer.booking_confirmation(current_user, @booking).deliver_now unless @booking.waitlisted?
      flash[:notice] = if @booking.waitlisted?
        "You've been added to the waitlist!"
      elsif @booking.status == "pending"
        "Your booking is pending the teacher’s approval."
      else
        "You are booked!"
      end

    else
      flash[:alert] =  @booking.errors.full_messages.to_sentence
    end

    redirect_back fallback_location: event_instance_path(@event_instance)
  end

  def update_state
    @booking = Booking.find(params[:id])
    @booking.update(state: params[:state])

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.replace(@booking)
      end
      format.html { redirect_to dashboard_path }
    end
  end


  def approve
    booking = Booking.find(params[:id])
    booking.update!(status: "confirmed")
    redirect_to dashboard_path, notice: "Booking approved"
  end

  def cancel
    booking = Booking.find(params[:id])
    booking.update!(status: "cancelled")
    redirect_to dashboard_path, notice: "Booking cancelled"
  rescue ActiveRecord::RecordNotFound
    redirect_to dashboard_path, alert: "Booking not found"
  rescue ActiveRecord::RecordInvalid => e
    redirect_to dashboard_path, alert: "Failed to cancel booking: #{e.message}"
  end


  def destroy
    @booking = Booking.find_by(id: params[:id])

    if @booking.nil?
      flash[:alert] = "Booking not found."
      redirect_back(fallback_location: root_path) and return
    end

    event_instance = @booking.event_instance
    was_waitlisted = @booking.waitlisted?
    is_pending = @booking.status == 'pending'

    # Allow students to cancel their own pending or waitlisted bookings anytime
    if is_pending && @booking.user == current_user
      was_waitlisted = @booking.waitlisted?
      @booking.destroy
      flash[:notice] = was_waitlisted ? "You have been removed from the waitlist." : "Booking request cancelled."
      return redirect_to event_instance_path(event_instance)
    end


    # Skip cutoff check if waitlisted
    if !was_waitlisted
      cancellation_cutoff = if event_instance.cancellation_policy_duration.present?
        event_instance.start_time - event_instance.cancellation_policy_duration.to_i.hours
      end

      if cancellation_cutoff.present? && Time.current > cancellation_cutoff
        flash[:alert] = "Cancellation is not allowed after the deadline. Please contact the teacher"
        return redirect_to event_instance_path(event_instance)
      end
    end

    @booking.destroy

    if was_waitlisted
      flash[:notice] = "You have been removed from the waitlist."
    else
      flash[:notice] = "Booking canceled successfully."
      BookingMailer.cancellation_confirmation(current_user, @booking).deliver_now
    end

    next_in_line = event_instance.bookings.where(waitlisted: true).order(:joined_at).first
    open_spots_available = event_instance.effective_capacity - event_instance.bookings.where(waitlisted: false).count > 0

    if next_in_line && open_spots_available
      if next_in_line.update(waitlisted: false, joined_at: nil)
        BookingMailer.booking_confirmation(next_in_line.user, next_in_line, moved_from_waitlist: true).deliver_now
        flash[:notice] += " A waitlisted user has been moved to the event!"
      else
        Rails.logger.error "⚠️ Failed to move waitlisted user: #{next_in_line.errors.full_messages}"
      end
    end
    redirect_to event_instance_path(event_instance)
  end


  # def destroy
  #   @booking = Booking.find_by(id: params[:id])

  #   if @booking.nil?
  #     flash[:alert] = "Booking not found."
  #     redirect_back(fallback_location: root_path) and return
  #   end
  #   if @booking.waitlisted? || booking.user == current_user
  #     @booking.destroy
  #     flash[:notice] = "You have been removed from the waitlist."
  #   else
  #     flash[:alert] = "You can't remove this booking."
  #   end
  #   redirect_to event_instance_path(@booking.event_instance)

  # end


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
      params.require(:booking).permit(:user_id, :state, :status) # Add any other required fields
    end
end
