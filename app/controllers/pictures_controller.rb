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
    if @picture.save
      if @picture.status
        flash[:success] = 'Image was added!'
        respond_with(@picture, location: owner_resto_edit_path(@picture.restaurant))
      else
        flash[:failure] = "<dl><dt>Your image was not added because:</dt>" 
        @picture.errors.full_messages.map { |msg| flash[:failure] << "<dd>#{msg}</dd>" }
        flash[:failure] << "</dl>"
        redirect_to restaurant_path(@picture.restaurant)
      end
    else
      flash[:failure] = "<dl><dt>Your image was not added because:</dt>" 
      @picture.errors.full_messages.map { |msg| flash[:failure] << "<dd>#{msg}</dd>" }
      flash[:failure] << "</dl>"
      if @picture.status
        redirect_to owner_resto_edit_path(@picture.restaurant)
      else
        redirect_to restaurant_path(@picture.restaurant)
      end
    end
  end
  
  def show
  end
  
  def update
    if @picture.update(picture_params)
      flash[:success] = 'Image successfully updated!'
      respond_with(@picture, location: owner_resto_edit_path(@picture.restaurant))
    else
      flash[:failure] = "<dl><dt>Your image was not updated successfully because:</dt>" 
      @picture.errors.full_messages.map { |msg| flash[:failure] << "<dd>#{msg}</dd>" }
      flash[:failure] << "</dl>"
      redirect_to owner_resto_edit_path(@picture.restaurant)
    end
  end
  
  def destroy
    if @picture.destroy
      flash[:success] = 'Image was deleted!'
      respond_with(@picture, location: owner_resto_edit_path(@picture.restaurant))
    else
      flash[:failure] = "<dl><dt>Your image was not deleted because:</dt>" 
      @picture.errors.full_messages.map { |msg| flash[:failure] << "<dd>#{msg}</dd>" }
      flash[:failure] << "</dl>"
      redirect_to owner_resto_edit_path(@picture.restaurant)
    end
  end
  
  private
  
  def picture_params
    params.require(:picture).permit(:pic, :restaurant_id, :status, :id)
  end
  
  def set_picture
    @picture = Picture.find(params[:id])
  end
end