class PicturesController < ApplicationController
  
  respond_to :html
  
  def create
    @picture = Picture.new(picture_params)
    @picture.user = current_user
    @picture.save
    respond_with(@picture, location: restaurant_path(@picture.restaurant))
  end
  
  private
  
  def picture_params
    params.require(:picture).permit(:pic, :restaurant_id)
  end
end