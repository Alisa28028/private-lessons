class BookingMailer < ApplicationMailer
  default from: 'arisa.segawa@gmail.com'

 def booking_confirmation(user, booking)
    @user = user
    @booking = booking
    @event_instance = booking.event_instance
    @event = @event_instance.event

    mail(to: @booking.user.email, subject: "Booking Confirmation for #{@event_instance.event.title}")
    # mail(to: @user.email, subject: "Booking Confirmation for #{@event_instance.event.title}")
  end
end
