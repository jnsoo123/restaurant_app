class CuisinesController < ApplicationController
  before_action :set_cuisine, only: [:edit, :update, :destroy]
  skip_before_action :authenticate_user!, only: :index
  respond_to :html
  
  def index
    @cuisines = Cuisine.order('name')
  end

end