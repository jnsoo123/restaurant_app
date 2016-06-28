class PicturesController < ApplicationController
  before_action :set_picture, only: [:update, :destroy, :show]
  skip_before_action :authenticate_user!, only: :show
  respond_to :html
  respond_to :js, only: :show
  
  
  def create
    @picture = Picture.new(picture_params)
    @picture.user = current_user
    if current_user === @picture.restaurant.user
      @picture.status = true
    end
    @picture.save
    flash[:success] = 'Image was added!'
    respond_with(@picture, location: (@picture.status ? owner_resto_edit_path(@picture.restaurant) : @picture.restaurant ))
  end
  
  def show
  end
  
  def update
    @picture.update(picture_params)
    respond_with(@picture, location: owner_resto_edit_path(@picture.restaurant))
  end
  
  def destroy
    @picture.destroy
    flash[:success] = 'Image was deleted.'
    respond_with(@picture, location: owner_resto_edit_path(@picture.restaurant))
  end
  
  private
  
  def picture_params
    params.require(:picture).permit(:pic, :restaurant_id, :status, :id)
  end
  
  def set_picture
    @picture = Picture.find(params[:id])
  end
end