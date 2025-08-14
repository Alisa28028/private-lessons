class Admin::DashboardController < ApplicationController
  before_action :authenticate_user!
  before_action :require_admin

  def index
    # Ahoy data
    @total_visits = Ahoy::Visit.count
    @total_events = Ahoy::Event.count

    # Visits by country
    @visits_by_country = Ahoy::Visit.group(:country).count || {}

    # Recent visits
    @recent_visits = Ahoy::Visit.order(started_at: :desc).limit(10)

    # User data
    @total_users = User.count
    @recent_users = User.order(created_at: :desc).limit(10)
  end



  private

  def require_admin
    redirect_to root_path unless current_user&.admin?
  end
end
