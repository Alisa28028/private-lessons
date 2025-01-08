class BookingMailer < ApplicationMailer
  default from: 'arisa.segawa@gmail.com'

 def booking_confirmation(user, booking)
    @user = user
    @event = booking.event
    @booking = booking
    mail(to: @user.email, subject: "Booking Confirmation for #{@event.title}")
  end
end
