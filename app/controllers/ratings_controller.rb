class RatingsController < ApplicationController
  
  respond_to :html
  
  def index
    if(params[:search_category].nil?)
      @ratings = Rating.order('rate DESC')
    else
      @ratings = Rating.sort(params[:search_category])
    end
  end
end