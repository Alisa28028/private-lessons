class CalculatorController < ApplicationController
  skip_before_action :authenticate_user!
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
      elsif commission >= 30000
        "negotiable"
      else
        "not_eligible"
      end

    CalculatorEntry.create!(
      lessons: lessons,
      attendees: attendees,
      price: price,
      commission: commission,
      status: status,
      user: current_user
    )

    render json: { commission: commission, status: status }
  end


end
