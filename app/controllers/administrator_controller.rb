class AdministratorController < ApplicationController
  def index #this is for showing list of users
    @users = User.order('updated_at DESC')
  end
end
