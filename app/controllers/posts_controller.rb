class PostsController < ApplicationController 
  before_action :set_post, only: [:edit, :update, :destroy]
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
      @posts = @post.restaurant.posts
      respond_with(@posts)
    else
      
    end
  end
  
  def edit
  end
  
  def update
    if @post.update(post_params)
      @posts = @post.restaurant.posts
      respond_with(@posts)
    else
      respond_with(@post)
    end
  end
  
  def destroy
    if @post.destroy
      @posts = @post.restaurant.posts
      respond_with(@posts)
    end
  end
  
  private
  
  def set_post
    @post = Post.find(params[:id])
  end
  
  def post_params
    params.require(:post).permit(:comment)
  end
end