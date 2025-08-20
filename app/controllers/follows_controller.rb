class FollowsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user

  def create
    current_user.following << @user unless current_user.following.include?(@user)

    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.replace("follow_button_#{@user.id}", partial: "users/follow_button", locals: { user: @user }) }
      format.html { redirect_back fallback_location: root_path }
    end
  end

  def destroy
    current_user.active_follows.find_by(followed_id: @user.id)&.destroy

    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.replace("follow_button_#{@user.id}", partial: "users/follow_button", locals: { user: @user }) }
      format.html { redirect_back fallback_location: root_path }
    end
  end

  private

  def set_user
    @user = User.find(params[:user_id])
  end
end
