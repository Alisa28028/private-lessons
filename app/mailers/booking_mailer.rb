class BookingMailer < ApplicationMailer
  default from: 'arisa.segawa@gmail.com'

  def booking_confirmation(user, booking, moved_from_waitlist: false)
    @user = user
    @booking = booking
    @event_instance = booking.event_instance
    @event = @event_instance.event
    @moved_from_waitlist = moved_from_waitlist

    if moved_from_waitlist
      subject = "A spot opened for #{@event.title}"
    elsif booking.status == "pending"
      subject = "Booking Request for #{@event.title}"
    else
      subject = "Booking Confirmation for #{@event.title}"
    end

    mail(to: @booking.user.email, subject: subject)
  end

    def cancellation_confirmation(user, booking)
      @user = user
      @booking = booking
      @event_instance = booking.event_instance
      @event = @event_instance.event

      subject = "You have successfully cancelled your booking for #{@event_instance.event.title}"
      mail(to: @booking.user.email, subject: subject)
    end

    def booking_approved(user, booking)
      @user = user
      @booking = booking
      @event_instance = booking.event_instance
      @event = @event_instance.event

      mail(to: @user.email, subject: "Your Booking for #{@event.title} Has Been Confirmed")
    end

    def booking_rejected(user, booking)
      @user = user
      @booking = booking
      @event_instance = booking.event_instance
      @event = @event_instance.event

      mail(to: @user.email, subject: "Your Booking Request for #{@event.title} Was Declined")
    end

end
