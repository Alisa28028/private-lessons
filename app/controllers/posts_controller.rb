class PostsController < ApplicationController
  def index
    @user = current_user
    @posts = Post.all
  end

  def show
    @post = Post.find(params[:id])
  end

  def new
    @post = if @event
      @event.posts.build # A new post for this event
    else
      Post.new #Blank post
  end

  def create
    @post = if @event
      @event.posts.build(post_params)
    else
      Post.new(post_params)
    end

    if @post.save
      redirect_to event_post_path(@event, @post), notice: 'Post was successfully created.'
    else
      render :new
    end
  end

    # @post = Post.new(post_params)
    # @post.user = current_user

    # if @post.save
    #   redirect_to @post, notice: 'Post successfully created.'
    # else
    #   render :new, status: :unprocessable_entity
    # end
  end


  def create_from_event
    @event = Event.find(params[:event_id])
    @post = Post.new(post_params)
    @post.user = current_user

    # Setting the title, description and video from the event
    @post.title = @event.title
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
