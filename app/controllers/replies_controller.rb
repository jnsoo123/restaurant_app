class RepliesController < ApplicationController

  respond_to :js
  
  def new
    @reply = Reply.new
    @reply.post = Post.find(params[:post]) if params[:post].present?
    @reply.rating = Rating.find(params[:rate]) if params[:rate].present?
    puts "@@@@@@@@@ #{params[:rate]}"
    respond_with(@reply)
  end
  
  def create
    @reply = Reply.new(reply_params)
    @reply.user = current_user
    @reply.post = Post.find(params[:post]) if params[:post].present?
    @reply.rating = Rating.find(params[:rate]) if params[:rate].present?
    if @reply.save
      @posts = @reply.post.restaurant.posts.order('created_at desc').limit(3) if params[:post].present?
      @restaurant = @reply.rating.restaurant if params[:rate].present?
      respond_with(@posts) if params[:post.present?]
      respond_with(@restaurant) if params[:rate].present?
    end
  end
  
  private
  
  def reply_params
    params.require(:reply).permit(:comment)
  end
  
end
