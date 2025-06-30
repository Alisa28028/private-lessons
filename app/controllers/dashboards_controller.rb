class DashboardsController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_dashboard_preference, except: [:select_preference, :update_preference]

  def show
    view = params[:view] || current_user.dashboard_preference

    case view
    when 'teacher'
      set_teacher_dashboard_data
      render 'dashboards/teacher'
    when 'student'
      set_student_dashboard_data
      render 'dashboards/student'
    else
      redirect_to select_dashboard_preference_path
    end
  end

  def select_preference
    # Renders selection form
  end

  def update_dashboard_preference
    if %w[teacher student].include?(params[:dashboard_preference])
      current_user.update(dashboard_preference: params[:dashboard_preference])
      redirect_to dashboard_path
    else
      redirect_to select_dashboard_preference_path, alert: "Please choose a valid option."
    end
  end

  private

  def ensure_dashboard_preference
    return if current_user.dashboard_preference.present?

    redirect_to select_dashboard_preference_path
  end

  def set_student_dashboard_data

  end

  def set_teacher_dashboard_data
    require 'time'

    @bookings = current_user.bookings
    @event_instances = EventInstance.joins(:event).where(events: { user_id: current_user.id }).includes(:bookings => :user)


    # Ensure @events is an ActiveRecord relation
    @events = current_user.events.presence || Event.none

    # Fetch upcoming event instances
    @upcoming_event_instances = EventInstance
      .left_joins(:event)
      .where('event_instances.start_time > ? AND (events.user_id = ? OR event_instances.id IN (?))',
             Time.now, current_user.id, @bookings.pluck(:event_instance_id))
      .order(start_time: :asc)

    # Fetch past event instances
    @past_event_instances = EventInstance
      .left_joins(:event)
      .where('event_instances.start_time <= ? AND (events.user_id = ? OR event_instances.id IN (?))',
             Time.now, current_user.id, @bookings.pluck(:event_instance_id))
      .order(start_time: :desc)


      # Upcoming events CREATED by current_user
    @upcoming_event_instances_created = EventInstance
    .joins(:event)
    .where('event_instances.start_time > ?', Time.current)
    .where(events: { user_id: current_user.id })
    .order(start_time: :asc)

    # Past events CREATED by current_user
    @past_event_instances_created = EventInstance
    .joins(:event)
    .where('event_instances.start_time <= ?', Time.current)
    .where(events: { user_id: current_user.id })
    .order(start_time: :desc)


    # Earnings Calculation
    @last_month_event_instances = EventInstance.where(start_time: Time.now.last_month.beginning_of_month..Time.now.last_month.end_of_month)
    # @last_month_events_sum = monthly_sum(@last_month_event_instances)

    @current_month_event_instances = EventInstance.where(start_time: Time.now.beginning_of_month..Time.now)
    # @current_month_events_sum = monthly_sum(@current_month_event_instances)

    start_of_month = Time.current.beginning_of_month
  end_of_month = Time.current.end_of_month

  @current_month_paid_sum = Booking
    .joins(event_instance: :event)
    .where(
      status: ["confirmed", "cancelled_by_teacher"],
      state: "paid")
    .where(events: { user_id: current_user.id })
    .where(event_instances: { start_time: start_of_month..end_of_month })
    .sum("event_instances.price_cents")

    @unpaid_booking_count = Booking
    .joins(:event_instance)
    .where(
      state: "unpaid",
      status: ["confirmed", "cancelled_by_teacher", "completed"],
      event_instances: { id: @event_instances.select(:id) }
    )
    .count

    @unpaid_bookings = Booking
    .joins(:event_instance)
    .where(
      state: "unpaid",
      status: ["confirmed", "cancelled_by_teacher", "completed"],
      event_instances: { id: @event_instances.select(:id) }
    )
    # Attended students
      @most_attended_list_current_month = most_attended(@current_month_event_instances)
      @most_attended_list_last_month = most_attended(@last_month_event_instances)

      @current_month_bookings = booking_count(@current_month_event_instances)
      @last_month_bookings = booking_count(@last_month_event_instances)

      # In your controller or scope that fetches bookings for the payment panel
      @bookings_to_pay = Booking
      .where(event_instance_id: @event_instances.pluck(:id))
      .where(status: ['confirmed', 'cancelled_by_teacher', 'completed'])

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
