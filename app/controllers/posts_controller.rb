class PostsController < ApplicationController
  def index
    @user = current_user
    @posts = Post.all
  end

  def show
    @post = Post.find(params[:id])
  end

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)
    @post.user = current_user

    if @post.save
      redirect_to @post, notice: 'Post successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end


  def create_from_event
    @event = Event.find(params[:id])
    @post = Post.new(post_params)
    @post.user = current_user
    @post.description = @event.description
    @post.videos.attach(@event.video) if @event.video.attached?
    if @post.save
      redirect_to @post, notice: 'Post created from event successfully.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    @post = Post.find(params[:id])
    @post.destroy
    redirect_to posts_path, status: :see_other
  end

  private

  def post_params
    params.require(:post).permit(:title, :description, :is_video, photos: [], videos: [])
  end
end
