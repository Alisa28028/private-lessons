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
    # if moved_from_waitlist
    #   mail(to: @booking.user.email, subject: "A spot opened for #{@event_instance.event.title}")
    # else
    # mail(to: @booking.user.email, subject: "Booking Confirmation for #{@event_instance.event.title}")
    # # mail(to: @user.email, subject: "Booking Confirmation for #{@event_instance.event.title}")
    end
end
