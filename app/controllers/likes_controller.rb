class LikesController < ApplicationController
  before_action :authenticate_user!
  def create
    @event_instance = EventInstance.find(params[:event_instance_id])
    @event_instance.likes.find_or_create_by(user: current_user)
    redirect_back fallback_location: event_instance_path(@event_instance)
  end

  def destroy
    @event_instance = EventInstance.find(params[:event_instance_id])
    like = @event_instance.likes.find_by(user: current_user)
    like.destroy if like
    redirect_back fallback_location: event_instance_path(@event_instance)
  end
end
