class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [ :home ]

  def home
    return redirect_to new_user_session_path unless current_user
    @event_instances = EventInstance.all

    @bookings = current_user&.bookings || []

    # Fetch events the user is teaching (associated with user) - for both Events and EventInstances
    @events = current_user.events || []  # Events user is teaching
    @event_instances = @events.map(&:event_instances).flatten
    # Fetch upcoming event instances (the user is attending or teaching)
    @event_instances = @events.map(&:event_instances).flatten
    @upcoming_event_instances = EventInstance.joins(:event)
                                .where('event_instances.start_time > ?', Time.now)
                                .order('event_instances.start_time ASC') || []
    # Fetch past event instances (the user is attending or teaching)
    @past_event_instances = EventInstance.joins(:event)
                            .where('event_instances.start_time <= ?', Time.now)
                            .order('event_instances.start_time DESC') || []


    # Get bookings for the current user
    if user_signed_in?
      @user = current_user
      @user_bookings = @user.bookings
    end
  end
end
