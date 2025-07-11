class PostsController < ApplicationController
  before_action :set_event, only: [:new, :create, :show, :destroy, :create_from_event_instance]
  before_action :set_event_instance, only: [:new, :create_from_event_instance]
  before_action :set_post, only: [:edit, :cancel_edit, :update, :destroy]
  before_action :authorize_post_owner, only: [:edit, :update, :destroy, :cancel_edit]
  before_action :authorize_hide_permission, only: [:hide]


  def index
    @user = current_user
    @posts = Post.all
    @event = Event.find_by(id: params[:event_id])
  end

  def show
    @post = Post.find(params[:id])
  end

  def teacher_posts
    @user = User.find(params[:id])
    teacher_posts = @user.posts.where(hidden: false)

    respond_to do |format|
      format.html { render partial: "users/teacher_posts", locals: { teacher_posts: teacher_posts } }
      format.turbo_stream
    end
  end

  def student_posts
    @user = User.find(params[:id])

    student_posts = Post
      .joins(:event_instance)
      .where(event_instances: { event_id: @user.events.pluck(:id) })
      .where.not(user_id: @user.id)
      .where("posts.hidden IS NULL OR posts.hidden = false")

    respond_to do |format|
      format.html {
        render partial: "users/student_posts",
               locals: { student_posts: student_posts }
      }
      format.turbo_stream
    end
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
      description: params[:post][:description],
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

  def edit
    from_event_show = params[:from_event_show] == "true"

    respond_to do |format|
      format.html do
        if turbo_frame_request?
          partial = from_event_show ? "posts/edit_form_noheader" : "posts/edit_form"
          render partial: partial, locals: { post: @post, from_event_show: from_event_show }
        else
          render :edit
        end
      end
    end
  end



  def cancel_edit
    from_event_show = params[:from_event_show] == "true"
    partial = from_event_show ? "posts/post_noheader" : "posts/post"
    render partial: partial, locals: { post: @post, from_event_show: from_event_show }
  end

  def update
    @post = Post.find(params[:id])
    from_event_show = params[:from_event_show] == "true"

    if @post.update(post_params)
      partial = from_event_show ? "posts/post_noheader" : "posts/post"

      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: turbo_stream.replace(
            "post_#{@post.id}",
            partial: partial,
            locals: { post: @post, from_event_show: from_event_show }
          )
        end
        format.html { redirect_to @post, notice: "Post updated" }
      end
    else
      render :edit, status: :unprocessable_entity
    end
  end


  # def hide
  #   @post = Post.find(params[:id])
  #   if @post.update(hidden: true)
  #     respond_to do |format|
  #       format.turbo_stream { render turbo_stream: turbo_stream.remove("post_#{@post.id}") }
  #       format.html { redirect_back fallback_location: root_path, notice: "Post hidden." }
  #     end
  #   else
  #     respond_to do |format|
  #       format.turbo_stream { render turbo_stream: turbo_stream.prepend("flash", partial: "shared/flash", locals: { alert: "Could not hide post." }) }
  #       format.html { redirect_back fallback_location: root_path, alert: "Could not hide post." }
  #     end
  #   end
  # end

  def hide
    @post = Post.find(params[:id])
    event = @post.event_instance&.event

    unless event && event.user == current_user
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: turbo_stream.replace("post_#{@post.id}", partial: "posts/post", locals: { post: @post, alert: "You are not authorized to hide this post." })
        end
        format.html { redirect_back fallback_location: root_path, alert: "You are not authorized to hide this post." }
      end
      return
    end

    if @post.update(hidden: true)
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_back fallback_location: root_path, notice: "Post hidden." }
      end
    else
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: turbo_stream.replace("post_#{@post.id}", partial: "posts/post", locals: { post: @post, alert: "Could not hide post." })
        end
        format.html { redirect_back fallback_location: root_path, alert: "Could not hide post." }
      end
    end
  end



  def destroy
    if @post.user != current_user
      respond_to do |format|
        format.turbo_stream { render turbo_stream: turbo_stream.update("flash", partial: "shared/flashes", locals: { alert: "You are not authorized to delete this post." }) }
        format.html { redirect_back fallback_location: root_path, alert: "You are not authorized to delete this post." }
      end
      return
    end

    @post_id = @post.id
    @post.destroy

    respond_to do |format|
      format.turbo_stream
      format.html do
        if params[:from] == "event_instance"
          redirect_to event_instance_path(params[:event_instance_id]), notice: "Post deleted.", status: :see_other
        elsif params[:from] == "user_profile"
          redirect_to user_path(current_user, anchor: "posts-tab"), notice: "Post deleted.", status: :see_other
        else
          redirect_back fallback_location: root_path, notice: "Post deleted.", status: :see_other
        end
      end
    end
  end



  private

  def can_hide_post?(post)
    return false unless current_user

    # Allow if current_user owns the post
    return true if post.user == current_user

    # Allow if current_user owns the event instance the post belongs to
    return true if post.event_instance.present? && post.event_instance.user == current_user

    false
  end


  def authorize_post_owner
    @post = Post.find(params[:id])
    redirect_to root_path, alert: "Not authorized." unless @post.user == current_user
  end

  def authorize_hide_permission
    @post = Post.find(params[:id])
    # Allow if current_user owns the post
    return if @post.user == current_user

    # Or allow if current_user owns the event that the event_instance belongs to
    if @post.event_instance.present?
      event_owner = @post.event_instance.event.user
      return if event_owner == current_user
    end

    redirect_to root_path, alert: "Not authorized to hide this post."
  end


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
