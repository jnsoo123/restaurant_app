class PicturesController < ApplicationController
  before_action :set_picture, only: [:update, :destroy, :show]
  skip_before_action :authenticate_user!, only: [:show, :show_more]
  respond_to :html
  respond_to :js, only: [:show, :show_more]
  
  
  def create
    @picture = Picture.new(picture_params)
    @picture.user = current_user
    if current_user === @picture.restaurant.user
      @picture.status = true
    end
    if @picture.save
      if @picture.status
        flash[:success] = t('.successowner')
        if params[:page].present? 
          respond_with(@picture, location: restaurant_path(@picture.restaurant))
        else
          respond_with(@picture, location: File.join(owner_resto_edit_path(@picture.restaurant), '#photo'))
        end
      else
        
        flash[:success] = t('.successuser')
        Notification.create(message: "#{view_context.link_to current_user.name, user_path(current_user)} added a photo on your restaurant: #{view_context.link_to @picture.restaurant.name, restaurant_path(@picture.restaurant)}. #{view_context.link_to 'Click Here', File.join(owner_resto_edit_path(@picture.restaurant),"#photo")} to view it from the dashboard.", user: @picture.restaurant.user)
        respond_with(@picture, location: restaurant_path(@picture.restaurant)) 
      end
    else
      flash[:failure] = "<dl><dt>#{t('.failurestart')}</dt>" 
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
      flash[:success] = t('.success')
      respond_with(@picture, location: File.join(owner_resto_edit_path(@picture.restaurant),"#photo"))
    else
      flash[:failure] = "<dl><dt>#{t('.failurestart')}</dt>" 
      @picture.errors.full_messages.map { |msg| flash[:failure] << "<dd>#{msg}</dd>" }
      flash[:failure] << "</dl>"
      redirect_to File.join(owner_resto_edit_path(@picture.restaurant),"#photo")
    end
  end
  
  def destroy
    if @picture.destroy
      flash[:success] = t('.success')
      respond_with(@picture, location: File.join(owner_resto_edit_path(@picture.restaurant),"#photo"))
    else
      flash[:failure] = "<dl><dt>#{t('.failurestart')}</dt>" 
      @picture.errors.full_messages.map { |msg| flash[:failure] << "<dd>#{msg}</dd>" }
      flash[:failure] << "</dl>"
      redirect_to owner_resto_edit_path(@picture.restaurant)
    end
  end
  
  def show_more 
    @all = params[:more]
    @restaurant = Restaurant.find(params[:id])
    respond_with(@all)
  end
  
  private
  
  def picture_params
    params.require(:picture).permit(:pic, :restaurant_id, :status, :id)
  end
  
  def set_picture
    @picture = Picture.find(params[:id])
  end
end