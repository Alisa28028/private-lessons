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
    is_waitlisted = @event_instance.effective_capacity <= @event_instance.bookings.where(waitlisted: false).where(status: ["confirmed"]).count

    # Determine status
    status = if is_waitlisted
                "pending"  # still needs approval to be confirmed
            elsif @event_instance.approval_mode == "manual"
                "pending"
            else
                "confirmed"
            end



    # require_payment_now = @event_instance.event.payment_obligation_on_booking?
    state = (status == "confirmed" && !is_waitlisted) ? "unpaid" : nil

    @booking = @event_instance.bookings.new(
      user: current_user,
      waitlisted: is_waitlisted,
      joined_at: is_waitlisted ? Time.current : nil,
      status: status,
      state: state
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

  def update_status
    @booking = Booking.find(params[:id])
    new_status = params[:status]

    if new_status == "confirmed"
      event_instance = @booking.event_instance

      if event_instance.active_bookings_count >= event_instance.effective_capacity.to_i
        flash[:alert] = "Cannot confirm booking — event is at full capacity."
      elsif @booking.update(status: "confirmed", state: "unpaid")
        BookingMailer.booking_approved(@booking.user, @booking).deliver_later
        flash[:notice] = "Booking confirmed and user notified."
      else
        flash[:alert] = "Failed to confirm booking."
      end
    elsif new_status == "rejected_by_teacher"
      if @booking.update(status: "rejected_by_teacher", cancelled_by: "teacher", state: nil)
        BookingMailer.booking_rejected(@booking.user, @booking).deliver_later
        flash[:notice] = "Booking rejected and user notified."
      else
        flash[:alert] = "Failed to reject booking." + @booking.errors.full_messages.join(", ")
      end
    end

      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.replace(
              "booking_#{@booking.id}",
              partial: "bookings/booking",
              locals: {
                booking: @booking,
                instance: @booking.event_instance
              }
            ),
            turbo_stream.replace(
              "event_instance_#{@booking.event_instance.id}",
              partial: "event_instances/event_instance",
              locals: { instance: @booking.event_instance }
            )
          ]
        end

        format.html { redirect_to dashboard_path }
      end
    end

  def update_payment_state
    @booking = Booking.find(params[:id])
    @booking.update(state: params[:state].presence)

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.replace(
          "payment_#{@booking.id}",
          partial: "payments/payment_row",
          locals: { booking: @booking }
        )
      end
      format.html {
        redirect_to request.referer || bookings_path, notice: "Payment status updated."
      }
    end
  end



  def approve
    booking = Booking.find(params[:id])
    booking.update!(status: "confirmed", state: "unpaid")
    redirect_to dashboard_path, notice: "Booking approved"
  end

  def cancel
    @booking = Booking.find(params[:id])
    cancelled_by = params[:cancelled_by]

    case cancelled_by
    when "teacher"
      @booking.update(status: "cancelled_by_teacher", cancelled_by: "teacher")
    when "student"
      @booking.update(status: "cancelled_by_teacher", cancelled_by: "student")
    else
      # fallback in case param is missing or invalid
      @booking.update(status: "cancelled_by_teacher")
    end

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.replace(
          "booking_#{@booking.id}",
          partial: "bookings/booking", locals: { booking: @booking }
        )
      end
      format.html { redirect_back fallback_location: root_path, notice: "Booking cancelled" }
    end
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

    # Allow students to cancel their own pending or waitlisted bookings anytime by destroying
    if (is_pending || was_waitlisted) && @booking.user == current_user
      @booking.destroy
      flash[:notice] = was_waitlisted ? "You have been removed from the waitlist." : "Booking request cancelled."
      return redirect_to event_instance_path(event_instance)
    end

    # Skip cutoff check if waitlisted
    unless was_waitlisted
      # Disallow cancellation if payment is required upon booking
      if event_instance.event.payment_obligation_on_booking?
        flash[:alert] = "Cancellations are not allowed for this event. Please contact the teacher."
        return redirect_to event_instance_path(event_instance)
      end

      cancellation_cutoff = if event_instance.cancellation_policy_duration.present?
        event_instance.start_time - event_instance.cancellation_policy_duration.to_i.hours
      end

      # If after cancellation deadline, disallow student self-cancellation (ask teacher)
      if cancellation_cutoff.present? && Time.current > cancellation_cutoff
        flash[:alert] = "Cancellation is not allowed after the deadline. Please contact the teacher."
        return redirect_to event_instance_path(event_instance)
      end
    end

    # If we reach here, it means the student is cancelling before the deadline and not waitlisted or pending,
    # so update status instead of destroying
    if @booking.user == current_user
      @booking.update(
        status: "cancelled_by_student",
        cancelled_by: "student",
        cancelled_at: Time.current
      )
      flash[:notice] = "Booking cancelled successfully."
      BookingMailer.cancellation_confirmation(current_user, @booking).deliver_now
    else
      # For others (e.g., teacher), allow destroy or handle separately if needed
      @booking.destroy
      flash[:notice] = "Booking cancelled."
    end

    next_in_line = event_instance.bookings.where(waitlisted: true).order(:joined_at).first
    open_spots_available = (event_instance.effective_capacity - event_instance.bookings.where(waitlisted: false).count) > 0

    Rails.logger.info "Next in line booking: #{next_in_line.inspect}"
    Rails.logger.info "Open spots available? #{open_spots_available}"

    if next_in_line && open_spots_available
      new_status = event_instance.approval_mode == "manual" ? "pending" : "confirmed"

      if next_in_line.update(waitlisted: false, joined_at: nil, status: new_status)
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
