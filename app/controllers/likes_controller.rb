class LikesController < ApplicationController 
  
  respond_to :js, only: [:create, :destroy]
  
  def create
    @like = Like.new
    @like.user = current_user
    @like.post = Post.find(params[:post_id]) if params[:post_id].present?
    @like.rating = Rating.find(params[:rate_id]) if params[:rate_id].present?
    if @like.save
      @more_reviews = params[:review] || nil
      @restaurant = @like.post.restaurant if params[:post_id].present?
      @restaurant = @like.rating.restaurant if params[:rate_id].present?
      @user = User.find(params[:user_page]) if params[:user_page].present?
      respond_with(@restaurant) 
    end
  end
  
  def destroy
    @like = Like.find(Post.find(params[:post]).likes.find_by(user: params[:user])) if params[:post].present?
    @like = Like.find(Rating.find(params[:rating]).likes.find_by(user: params[:user])) if params[:rating].present?
    if @like.destroy
      @more_reviews = params[:review] || nil
      @restaurant = @like.post.restaurant if params[:post].present?
      @restaurant = @like.rating.restaurant if params[:rating].present?
      @user = User.find(params[:user_page]) if params[:user_page].present?
      respond_with(@restaurant)
    end
  end
  
end