class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [ :home ]

  def home
    @events = Event.all
    # Filter future and past events
    @future_events = @events.where("start_date >= ?", Time.zone.now.beginning_of_day)
    @past_events = @events.where("start_date < ?", Time.zone.now.beginning_of_day)

    # Get bookings for the current user
    if user_signed_in?
      @user = current_user
      @user_bookings = @user.bookings
    end
  end
end
