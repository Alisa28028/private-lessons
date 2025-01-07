class BookingMailer < ApplicationMailer
  default from: 'arisa.segawa@gmail.com'

 def booking_confirmation(user)
  @user = current_user
  @event = user.bookings.last.event
  mail(to: @user.email, subject: "Booking Confirmation for #{@event.title}")
 end
end
