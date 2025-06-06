class LocationsController < ApplicationController
  before_action :authenticate_user! # if you're using Devise for authentication


  def index
    # @locations = current_user.locations
    @locations = Location.where(user_id: current_user.id)
                          .where('name LIKE ?', "%#{params[:query]}%")
    render json: @locations
  end

  def search
    # Retrieve the locations associated with the current user and match the query
    query = params[:query].downcase
    locations = Location.where('LOWER(name) LIKE ?', "%#{query}%")
    render json: locations
  end

  def new
    @location = Location.new
  end

  def create
    @location = Location.new(location_params)
    @location.users << current_user

    if @location.save
      # Instead of redirecting, send back the location ID and name as JSON
      render json: { location_id: @location.id, location_name: @location.name }, status: :created
    else
      # If there's an error, send the error messages back as JSON
      render json: { success: false, errors: @location.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # def create
  #   # @location = current_user.locations.build(location_params)
  #   @location = Location.new(location_params)
  #   @location.users << current_user

  #   if @location.save
  #     redirect_to @location
  #     # render json: { success: true, location: location }, status: :created
  #   else
  #     render :new
  #     # render json: { success: false, errors: location.errors.full_messages }, status: :unprocessable_entity
  #   end
  # end

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
