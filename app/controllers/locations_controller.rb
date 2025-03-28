class LocationsController < ApplicationController
  before_action :authenticate_user! # if you're using Devise for authentication

  def new
    @location = Location.new
  end

  def create
    @location = current_user.locations.build(location_params)

    if @location.save
      redirect_to locations_path, notice: 'Location was successfully created.'
    else
      render :new
    end
  end

  private

  def location_params
    params.require(:location).permit(:name, :address, :latitude, :longitude)
  end
end
