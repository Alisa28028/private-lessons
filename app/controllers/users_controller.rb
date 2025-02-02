class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :classes, :teacher_posts, :student_posts]

  def dashboard
    require 'time'
    @bookings = current_user.bookings
    @events = current_user.events

    # Fetch and filter event instances for the current user
    @event_instances = EventInstance.where(event_id: @events.pluck(:id))
    .where("date > ?", Time.now)  # Get future event instances
    .order(:date)  # Sort by date

  # Optional: For past event instances
  @past_event_instances = EventInstance.where(event_id: @events.pluck(:id))
        .where("date <= ?", Time.now)  # Get past event instances
        .order(:date)  # Sort by date

    # Earnings: look for events for last month and current month, then pass it as an argument to private method iterating on each event to find paid bookings and multiply by event price
    @last_month_events = @events.where(start_date: (Time.now.beginning_of_month.prev_month).midnight..(Time.now.beginning_of_month - 1).midnight)
    @last_month_events_sum = monthly_sum(@last_month_events)
    @current_month_events = @events.where(start_date: (Time.now.beginning_of_month).midnight..Time.now)
    @current_month_events_sum = monthly_sum(@current_month_events)
    # Most attended students: in a private method, iterate through bookings paid during a given month to sort attendees by frequency
    @most_attended_list_current_month = most_attended(@current_month_events)
    @most_attended_list_last_month = most_attended(@last_month_events)
    # Attending students this/last mexit
    # based on last/current month events (see above), count bookings for each one and sum
    @current_month_bookings = booking_count(@current_month_events)
    @last_month_bookings = booking_count(@last_month_events)
  end

  def show
    @bookings = current_user.bookings
    @events = @user.events
    # Get the event instances related to the user's bookings
    @event_instances = EventInstance.where(id: @bookings.pluck(:event_instance_id)).where("date > ?", Time.now).order(:date)

    # Get the associated events for the future event instances
    @events = @event_instances.map(&:event).uniq

    @attending_events = @user.bookings.includes(:event).map(&:event)
  end

  def edit

  end

  def classes
    # Fecth the classes for the teacher
    @events = @user.events
    render partial: 'users/classes', locals: { events: @events }
    # render turbo_stream: turbo_stream.replace('classes', partial: 'users/classes', locals: { events: @events })
  end

  def teacher_posts
    # Fetch posts by the teacher
    @posts = @user.posts
      # flash.now[:notice] = "No posts yet" if @posts.nil? || @posts.empty?
    render partial: 'users/teacher_posts', locals: { posts: @posts }
    # render turbo_stream: turbo_stream.replace('teacher_posts', partial: 'users/teacher_posts', locals: { posts: @posts })
  end

  def student_posts
    @student_posts = @user.events.includes(:posts).flat_map(&:posts)
    render partial: 'users/student_posts', locals: { posts: @student_posts }
  end


  def update
    @user = current_user
    @user.update(user_params)
    redirect_to user_path(@user)
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :description, :photo)
  end

  def set_user
    @user = User.find(params[:id])
  end

  def monthly_sum(monthly_events)
    monthly_sum = 0
    monthly_events.each do |event|
      paid_bookings = event.bookings.where(state: "paid")
      event_revenue = paid_bookings.count * event.price_cents
      monthly_sum += event_revenue
    end
    monthly_sum
  end

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
