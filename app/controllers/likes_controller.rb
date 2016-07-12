class LikesController < ApplicationController 
  
  respond_to :js, only: [:create, :destroy]
  
  def create
    @like = Like.new
    @like.user = current_user
    @like.post = Post.find(params[:post_id]) if params[:post_id].present?
    @like.rating = Rating.find(params[:rate_id]) if params[:rate_id].present?
    if @like.save
      @posts = @like.post.restaurant.posts.order('created_at desc').limit(3) if params[:post_id].present?
      @restaurant = @like.rating.restaurant if params[:rate_id].present?
      respond_with(@posts) if params[:post_id].present?
      respond_with(@restaurant) if params[:rate_id].present?
    end
  end
  
  def destroy
    @like = Like.find(Post.find(params[:post]).likes.find_by(user: params[:user])) if params[:post].present?
    @like = Like.find(Rating.find(params[:rating]).likes.find_by(user: params[:user])) if params[:rating].present?
    if @like.destroy
      @posts = @like.post.restaurant.posts.order('created_at desc').limit(3) if params[:post].present?
      @restaurant = @like.rating.restaurant if params[:rating].present?
      puts "@@@@@@@@@@@ #{params[:post]}"
      puts "@@@@@@@@@@@ #{params[:rating]}"
      respond_with(@posts) if params[:post].present?
      respond_with(@restaurant) if params[:rating].present?
    end
  end
  
end