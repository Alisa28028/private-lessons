class UsersController < ApplicationController
  skip_before_action :authenticate_user!
  before_action :set_user, only: [:show, :edit, :update, :classes, :teacher_posts, :student_posts]
  include ActionView::Helpers::AssetUrlHelper
  include ActionView::Helpers::AssetTagHelper
  include ApplicationHelper

  # def show
  #   @bookings = current_user.bookings
  #   @events = @user.events
  #   # Get the event instances related to the user's bookings
  #   @event_instances = EventInstance.where(id: @bookings.pluck(:event_instance_id)).where("date > ?", Time.now).order(:date)

  #   # Get the associated events for the future event instances
  #   @events = @event_instances.map(&:event).uniq

  #   @attending_events = current_user.bookings.includes(:event_instance).map(&:event_instance).compact
  # end

#   def show
#   @user = current_user # or User.find(params[:id])
#   @event_instances = current_user.bookings.includes(:event_instance).map(&:event_instance).compact

#   created_event_instances = current_user.events.includes(:event_instances).flat_map(&:event_instances)
#   @all_event_instances = (created_event_instances + @event_instances).uniq

#   # Render the user show page with the necessary instance variables
# end

def show
  @user = User.find(params[:id])
  @upcoming_event_instances = EventInstance
    .joins(:event)
    .where(events: { user_id: @user.id }) # Events created by this user
    .where('event_instances.start_time > ?', Time.current) # Only future events
    .order(start_time: :asc)

    @weekly_availabilities = @user.weekly_availabilities.group_by(&:day_before_type_cast)
    @weekly_schedule = (0..6).map do |day|
    {
      day: Date::DAYNAMES[day],
      slots: (@weekly_availabilities[day] || []).map do |wa|
        {
          time: "#{wa.start_time.strftime('%H:%M')}–#{wa.end_time.strftime('%H:%M')}",
          style: wa.style,
          location: wa.studio&.name || wa.location,
          icon: wa.studio&.icon&.attached? ? url_for(wa.studio.icon) : nil
        }
      end
    }
  end

end

def home

end

def edit
  @user = current_user
  @user.weekly_availabilities.build if @user.weekly_availabilities.empty?
end

def update
  if @user.update(user_params)
    redirect_to @user, notice: 'Profile updated successfully.'
  else
    flash.now[:alert] = "Failed to update profile."
    render :edit, status: :unprocessable_entity
  end
end



  # def classes
  #   @event_instances = current_user.bookings.includes(:event_instance).map(&:event_instance).compact
  #   respond_to do |format|
  #     format.turbo_stream { render turbo_stream: turbo_stream.replace("teacher_content", partial: "users/classes", locals: { event_instances: @event_instances }) }
  #     format.html { render partial: "users/classes", locals: { event_instances: @event_instances } }
  #   end
  # end

  def classes
    # Ensure @events is an ActiveRecord relation
    @events = current_user.events.presence || Event.none
    # Fetch upcoming event instances
    @upcoming_event_instances = EventInstance
      .joins(:event)
      .where(events: { user_id: current_user.id })
      .where('event_instances.start_time > ?', Time.current)
      .order(start_time: :asc)
    puts "All upcoming Event Instances: #{@upcoming_event_instances.count}"  # Debugging line
    render partial: 'users/classes', locals: { event_instances: @upcoming_event_instances }, formats: [:html]
  end


  def teacher_posts
    # Fetch posts by the teacher
    @teacher_posts = @user.posts
      # flash.now[:notice] = "No posts yet" if @posts.nil? || @posts.empty?
    render partial: 'users/teacher_posts', locals: { teacher_posts: @teacher_posts }, formats: [:html]
    # render turbo_stream: turbo_stream.replace('teacher_posts', partial: 'users/teacher_posts', locals: { posts: @posts })
  end

  # def student_posts
  #   @student_posts = @user.events.includes(:posts).flat_map(&:posts)
  #   render partial: 'users/student_posts', locals: { posts: @student_posts }
  # end
  # def student_posts
  #   @student_posts = Post.where(user_id: current_user.id) # Adjust this query as needed
  #   render partial: 'users/student_posts', locals: { student_posts: @student_posts }
  # end

  def student_posts
    # Find event instances created by the teacher (the profile we are on)
    teacher_event_instances = EventInstance.joins(:event).where(events: { user_id: @user.id })

    # Find students who booked any of these event instances
    student_ids = Booking.where(event_instance_id: teacher_event_instances.pluck(:id)).pluck(:user_id).uniq

    # Get posts from these students
    @student_posts = Post.where(user_id: student_ids)

    @student_posts ||= []
    Rails.logger.debug "Student Posts: #{@student_posts.inspect}"

    render partial: 'users/student_posts', locals: { student_posts: @student_posts }, formats: [:html]
  end



  def update
    @user = current_user
    @user.update(user_params)
    redirect_to user_path(@user)
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :time_zone, :password_confirmation, :description, :photo, :instagram, :x, :tiktok,
      weekly_availabilities_attributes: [
      :id, :day, :start_time_str, :end_time_str, :style, :studio_id, :location, :_destroy
    ])
  end

  def set_user
    @user = User.find(params[:id])
  end

  # def monthly_sum(monthly_events)
  #   monthly_sum = 0
  #   monthly_events.each do |event|
  #     paid_bookings = event.bookings.where(state: "paid")
  #     event_revenue = paid_bookings.count * event.price_cents
  #     monthly_sum += event_revenue
  #   end
  #   monthly_sum
  # end

  def most_attended(monthly_events)
    most_attended = []
    monthly_events.each do |event|
      paid_bookings = event.bookings.where(state: "paid") # paid bookings during a given month
      event_attendees = []
      paid_bookings.each do |booking|
        event_attendee = booking.user_id # extracting user for each booking
        event_attendees << event_attendee # adding user to attendee list
      end
      most_attended << event_attendees
    end
    array = most_attended.flatten.uniq.map do |user_id|
      { user_id => most_attended.flatten.count(user_id)}
    end
    array.sort_by { |element| element.values[0] }.reverse[0..9]
  end

  def booking_count(monthly_events)
    booking_count = 0
    monthly_events.each do |event|
      booking_count += event.bookings.count
    end
    booking_count
  end
end
