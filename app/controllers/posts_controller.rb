class PostsController < ApplicationController
  before_action :set_event_instance, only: [:new, :create]
  before_action :set_event, only: [:new, :create, :show, :create_from_event, :destroy]

  def index
    @user = current_user
    @posts = Post.all
    @event = Event.find_by(id: params[:event_id])
  end

  def show
    @post = Post.find(params[:id])
  end

  def new
    @event = Event.find(params[:event_id])
    @event_instance = @event.event_instances.find_by(id: params[:event_instance_id]) # safe lookup

    @post = @event.posts.new

    if @event.videos.attached? && @event.videos.first.present?
      @post.videos.attach(@event.videos.first.blob)
    end
  end


  def create
    if @event
      @post = @event.posts.new(post_params)
    else
      @post = Post.new(post_params)
    end

    @post.user = current_user

  # Check if a video is uploaded or associated with the post
  # Attach videos if provided (this applies to both post creation from event and from scratch)
    if params[:post][:videos]
    @post.videos.attach(params[:post][:videos])
    end

    if @post.save
      if params[:event_instance_id].present?
        redirect_to event_instance_path(params[:event_instance_id]), notice: "Post created successfully."
      else
        redirect_to teacher_posts_user_path(current_user), notice: "Post created successfully."
      end
    else
      render :new
    end

  end


  def create_from_event

    @post = @event.posts.new(
      title: @event.title,
      description: @event.description,
      user: current_user
    )

    @event.videos.each do |video|
      @post.videos.attach(video)
    end
    if @post.save
      if @event
        redirect_to event_instance_path(@event), notice: 'Post was successfully created for this event.'
      else
        redirect_to user_path(current_user, anchor: "posts-tab"), notice: 'Post was successfully created.'
      end
    else
      render :new, status: :unprocessable_entity
    end

  end

  def save
    @post = Post.find_or_initialize_by(id: params[:id])
    if @post.update(post_params)
      redirect_to @post, notice: 'post was successfully saved.'
    else
      render :edit
    end
  end


  def destroy
    @post = Post.find(params[:id])
    @post.destroy
    redirect_to posts_path, status: :see_other
  end

  private

  def set_event_instance
    @event_instance = EventInstance.find(params[:event_instance_id]) if params[:event_instance_id].present?
  end

  def set_event
    @event = Event.find_by(id: params[:event_id])
  end

  def post_params
    params.require(:post).permit(:title, :content, :description, :event_id, :is_video, photos: [], videos: [])
  end
end
