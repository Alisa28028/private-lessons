class PostsController < ApplicationController
  before_action :set_event, only: [:new, :create, :show, :destroy, :create_from_event_instance]
  before_action :set_event_instance, only: [:new, :create_from_event_instance]
  before_action :set_post, only: [:destroy]


  def index
    @user = current_user
    @posts = Post.all
    @event = Event.find_by(id: params[:event_id])
  end

  def show
    @post = Post.find(params[:id])
  end

  def new
      @event_instance = EventInstance.find(params[:event_instance_id])
      @event = @event_instance.event
      @post = Post.new

    if @event_instance.videos.attached? && @event_instance.videos.first.present?
      @post.videos.attach(@event_instance.videos.first.blob)
    end
  end

  def new_from_event_instance
    @event = Event.find(params[:event_id])
    @event_instance = EventInstance.find(params[:event_instance_id])
    @post = Post.new
  end

  def create
    if params[:event_instance_id]
      @event_instance = EventInstance.find(params[:event_instance_id])
      @event = @event_instance.event
      @post = @event.posts.new(post_params) # OR associate with event_instance if needed
    else
      @post = Post.new(post_params)
    end

    @post.user = current_user

    @post.videos.attach(params[:post][:videos]) if params[:post][:videos]

    if @post.save
      # if @event_instance
      #   redirect_to event_instance_path(@event_instance), notice: "Post created successfully."
      # else
        redirect_to user_path(current_user, anchor: "posts-tab"), notice: "Post created successfully."
    else
      render :new
    end
  end


  def create_from_event_instance
    @event = Event.find(params[:event_id])
    @event_instance = EventInstance.find(params[:event_instance_id])

    @post = @event.posts.new(
      title: @event.title,
      description: @event.description,
      user: current_user,
      event_instance_id: @event_instance.id
    )

    @event.videos.each do |video|
      @post.videos.attach(video)
    end

    if @post.save
      redirect_to event_instance_path(@event_instance), notice: "Post created successfully."
    else
      render :new_from_event_instance
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
    if @post.user != current_user
      redirect_back fallback_location: root_path, alert: "You are not authorized to delete this post."
      return
    end

    @post.destroy

    if params[:from] == "event_instance"
      redirect_to event_instance_path(params[:event_instance_id]), notice: "Post deleted.", status: :see_other
    else
      redirect_to user_path(current_user, anchor: "posts-tab"), notice: "Post deleted.", status: :see_other
    end
  end


  private

  def set_event_instance
    @event_instance = EventInstance.find(params[:event_instance_id]) if params[:event_instance_id].present?
  end

  def set_post
    @post = Post.find(params[:id])
  end

  def set_event
    @event = Event.find_by(id: params[:event_id])
  end

  def post_params
    params.require(:post).permit(:title, :content, :description, :event_id, :is_video, photos: [], videos: [])
  end
end
