class LocationsController < ApplicationController
  before_action :authenticate_user! # if you're using Devise for authentication


  def index
    @locations = current_user.locations
  end

  def new
    @location = Location.new
  end

  def create
    # @location = current_user.locations.build(location_params)
    @location = Location.new(location_params)
    @location.users << current_user

    if @location.save
      redirect_to @location
      # render json: { success: true, location: location }, status: :created
    else
      render :new
      # render json: { success: false, errors: location.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # def autocomplete
  #   query = params[:query]
  #   @locations = current_user.locations.where("name LIKE ?", "%#{query}%")

  #   render json: @locations.pluck(:name)
  # end

  private

  def location_params
    params.require(:location).permit(:name, :address, :latitude, :longitude)
  end
end
