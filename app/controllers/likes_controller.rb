class LikesController < ApplicationController
  before_action :set_event_instance

  def create
    @event_instance.likes.create(user: current_user)

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.replace(
          "like_#{@event_instance.id}",
          partial: "event_instances/like_button",
          locals: { instance: @event_instance }
        )
      end
      format.html { redirect_to request.referer || root_path }
    end
  end

  def destroy
    @event_instance.likes.find_by(user: current_user)&.destroy

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.replace(
          "like_#{@event_instance.id}",
          partial: "event_instances/like_button",
          locals: { instance: @event_instance }
        )
      end
      format.html { redirect_to request.referer || root_path }
    end
  end

  private

  def set_event_instance
    @event_instance = EventInstance.find(params[:event_instance_id])
  end
end
