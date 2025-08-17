class Admin::DashboardController < ApplicationController
  before_action :authenticate_user!
  before_action :require_admin

  def index
    # Ahoy data
    @total_visits = Ahoy::Visit.count
    @total_events = Ahoy::Event.count
    @todays_visits = Ahoy::Visit.where("started_at >= ?", Time.zone.now.beginning_of_day).count


    # Visits by country
    @visits_by_country = Ahoy::Visit.group(:country).count || {}

    # Recent visits
    @recent_visits = Ahoy::Visit.order(started_at: :desc).limit(10)

    # User data
    @total_users = User.count
    @recent_users = User.order(created_at: :desc).limit(100)

    # Event instances
    @total_event_instances = EventInstance.count

    # Bookings
    @total_bookings = Booking.count

    # Top pages
  @top_pages_all_time = top_pages(Ahoy::Event.all)
  @top_pages_today = top_pages(Ahoy::Event.where("time >= ?", Time.zone.now.beginning_of_day))
  @top_pages_this_week = top_pages(Ahoy::Event.where("time >= ?", Time.zone.now.beginning_of_week))
  end



  private

  def require_admin
    redirect_to root_path unless current_user&.admin?
  end

  def top_pages(events_scope, limit = 10)
    events_scope
      .where(name: "Viewed page")
      .group("properties ->> 'url'")
      .order('count_all DESC')
      .limit(limit)
      .count
  end
end
