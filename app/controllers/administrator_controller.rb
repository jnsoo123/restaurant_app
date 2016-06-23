class AdministratorController < ApplicationController
  before_action :authenticate_user!
  
  def index #this is for showing list of users
    @users = User.order('username')
  end
end
