class AdministratorController < ApplicationController
  before_action :set_cuisine, only: [:edit, :update, :destroy]
  before_action :set_restaurant, only: [:accept, :reject]
 # respond_to :html
  
  def index #this is for showing list of users
    @users = User.all
  end
#------------------------------------------------  
  def restaurants
    @restos_accepted = Restaurant.where(status: "accepted")
    @restos_rejected = Restaurant.where(status: "rejected")
    @restos_ongoing = Restaurant.where(status: "ongoing")
  end
  
  def accept
    @restaurant.update_attribute(:status, 'accepted')
    redirect_to restaurants_index_path
  end
  
  def reject
    @restaurant.update_attribute(:status, 'rejected')
    UserMailer.welcome_email(@user).deliver_later
    redirect_to restaurants_index_path
  end
  
  
#------------------------------------------------  
  
  # def comments
 #  end
#------------------------------------------------ 
  def cuisines
    @cuisines = Cuisine.all
  end
  
  def new
    @cuisine = Cuisine.new
  end
  
  def create
    @cuisine = Cuisine.new(cuisine_params)
    @cuisine.save
    redirect_to cuisines_index_path
  end
  
  def edit
  end
  
  def update
    @cuisine.update(cuisine_params)
    redirect_to cuisines_index_path
  end
  
  def destroy
    @cuisine.destroy
    redirect_to cuisines_index_path
  end
  
#------------------------------------------------------  
  private
  
  def set_restaurant
    @restaurant = Restaurant.find(params[:id])
  end
  
  def set_cuisine
    @cuisine = Cuisine.find(params[:id])
  end
  
  def cuisine_params
    params.require(:cuisine).permit(:name, :description)
  end
    # def set_comments
  #     @comments = Comment.all
  #   end

end
