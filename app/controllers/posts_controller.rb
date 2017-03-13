class PostsController < ApplicationController
  before_action :set_post, only: [:edit, :update, :destroy]
  skip_before_action :authenticate_user!, only: :show_more
  respond_to :js

  def new
    @post = Post.new
    @post.restaurant = current_user.restaurants.find(params[:resto_id])
    respond_with(@post)
  end

  def create
    @post = Post.new(post_params)
    @post.restaurant = current_user.restaurants.find(params[:resto_id])
    if @post.save
      @posts = @post.restaurant.posts.page params[:page]
      respond_with(@posts)
    else
      @err = "<dl><dt>#{t('.failurestart')}</dt>"
      @post.errors.full_messages.map { |msg| @err << "<dd>#{msg}</dd>" }
      @err << "</dl>"
      respond_with(@posts)
    end
  end

  def edit
  end

  def update
    if @post.update(post_params)
      @posts = @post.restaurant.posts.page params[:page]
      respond_with(@posts)
    else
      @err = "<dl><dt>#{t('.failurestart')}</dt>"
      @post.errors.full_messages.map { |msg| @err << "<dd>#{msg}</dd>" }
      @err << "</dl>"
      respond_with(@post)
    end
  end

  def destroy
    if @post.destroy
      @posts = @post.restaurant.posts.page params[:page]
      respond_with(@posts)
    end
  end

  def show_more
    @all = params[:more] || nil
    @post_id = params[:post_id]
    @restaurant = Restaurant.find(params[:id])
    respond_with(@all)
  end

  private

  def set_post
    @post = Post.find(params[:id])
  end

  def post_params
    params.require(:post).permit(:comment)
  end
end
