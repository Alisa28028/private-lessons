class CalculatorController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index, :create, :save_guest_info]
  def index

  end

  def create
    lessons = params[:calculator_entry][:lessons].to_i
    attendees = [params[:calculator_entry][:attendees].to_i, 50].min
    price = params[:calculator_entry][:price].to_i
    commission = (lessons * attendees * price * 0.15).to_i

    status =
      if commission >= 40000
        "eligible"
      elsif commission >= 20000
        "negotiable"
      else
        "not_eligible"
      end

    # use session token for guests
    session[:calculator_token] ||= SecureRandom.hex(10)

    CalculatorEntry.create!(
      lessons: lessons,
      attendees: attendees,
      price: price,
      commission: commission,
      status: status,
      user: current_user,
      session_token: session[:calculator_token]
    )

    render json: { commission: commission, status: status }
  end

  def save_guest_info
    token = session[:calculator_token]
    entry = CalculatorEntry.where(session_token: token).order(created_at: :desc).first

    if entry.present?
      entry.update(
        guest_name: params[:name],
        email: params[:email]
      )
    end

    render json: { success: true }
  end
end
