class VideosController < ApplicationController
  def create
    # Ensure a file was uploaded
    if params[:video].blank? || params[:video][:file].blank?
      redirect_back fallback_location: root_path, alert: "Please select a video file to upload."
      return
    end

    # Upload video to Cloudinary
    uploaded_video = Cloudinary::Uploader.upload(params[:video][:file], resource_type: :video)

    # Create the video record
    @video = Video.new(
      url: uploaded_video['secure_url'],
      event_id: params[:video][:event_id], # Make sure form sends these as `video[event_id]`
      event_instance_id: params[:video][:event_instance_id],
      user: current_user
    )

    if @video.save
      # Redirect to the appropriate page
      if @video.event_instance_id.present?
        redirect_to event_instance_path(@video.event_instance_id), notice: "Video uploaded successfully!"
      elsif @video.event_id.present?
        redirect_to event_path(@video.event_id), notice: "Video uploaded successfully!"
      else
        redirect_to root_path, notice: "Video uploaded successfully!"
      end
    else
      redirect_back fallback_location: root_path, alert: "Error uploading video."
    end
  end
end
