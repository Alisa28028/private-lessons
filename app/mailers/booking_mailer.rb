class BookingMailer < ApplicationMailer
  default from: 'arisa.segawa@gmail.com'

  def booking_confirmation(user, booking, moved_from_waitlist: false)
    @user = user
    @booking = booking
    @event_instance = booking.event_instance
    @event = @event_instance.event
    @moved_from_waitlist = moved_from_waitlist

    subject = moved_from_waitlist ? "A spot opened for #{@event_instance.event.title}" : "Booking Confirmation for #{@event_instance.event.title}"

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
end
