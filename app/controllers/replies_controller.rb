class RepliesController < ApplicationController

  respond_to :js
  
  def new
    @reply = Reply.new
    @reply.post = Post.find(params[:post]) if params[:post].present?
    @reply.rating = Rating.find(params[:rate]) if params[:rate].present?
    @user = User.find(params[:user]) if params[:user].present?
    @more_reviews = params[:review] || nil
    respond_with(@reply)
  end
  
  def create
    @reply = Reply.new(reply_params)
    @reply.user = current_user
    @reply.post = Post.find(params[:post]) if params[:post].present?
    @reply.rating = Rating.find(params[:rate]) if params[:rate].present?
    if @reply.save
      @more_reviews = params[:review] || nil
      @restaurant = @reply.rating.restaurant if params[:rate].present?
      @restaurant = @reply.post.restaurant if params[:post].present?
      @user = User.find(params[:reply][:user]) if params[:reply][:user].present?
      respond_with(@restaurant)
    end
  end
  
  def destroy 
    @reply = Reply.find(params[:id])
    if @reply.destroy
      @more_reviews = params[:review] || nil
      @restaurant = @reply.rating.restaurant if params[:rate].present?
      @restaurant = @reply.post.restaurant if params[:post].present?
      @user = User.find(params[:user]) if params[:user].present?
      respond_with(@restaurant)
    end
  end
  
  private
  
  def reply_params
    params.require(:reply).permit(:comment)
  end
  
end
