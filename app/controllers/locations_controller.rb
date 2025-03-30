class LocationsController < ApplicationController
  before_action :authenticate_user! # if you're using Devise for authentication

  def new
    @location = Location.new
  end

  def create
    @location = current_user.locations.build(location_params)

    if location.save
      render json: { success: true, location: location }, status: :created
    else
      render json: { success: false, errors: location.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def location_params
    params.require(:location).permit(:name, :address, :latitude, :longitude)
  end
end
