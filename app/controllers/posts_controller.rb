class PostsController < ApplicationController
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
    if @event
      @post = @event.posts.new
    else
      @post = Post.new
    end
  end

  def create
    if @event
      @post = @event.posts.new(post_params)
    else
      @post = Post.new(post_params)
    end

    @post.user = current_user

    if @post.save
      redirect_to @post, notice: 'Post was successfully created.'
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
      redirect_to @post, notice: 'Post created from event successfully.'
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

  def set_event
    @event = Event.find_by(id: params[:event_id])
  end

  def post_params
    params.require(:post).permit(:title, :description, :event_id, :is_video, photos: [], videos: [])
  end
end
