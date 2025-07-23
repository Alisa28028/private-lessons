class FavoritesController < ApplicationController
  before_action :authenticate_user!



  def index
    @favorites = current_user.liked_event_instances.includes(:event, :bookings)
  end

end
