class SchedulesController < ApplicationController
  before_action :set_schedule, only: [:edit, :update, :destroy]
  respond_to :html
  respond_to :js, only: [:new, :edit, :create]

  def new
    @days = []
    Date::DAYNAMES.each_with_index { |x, i| @days << [x, x] }
    @schedule = Schedule.new
    @schedule.restaurant = current_user.restaurants.find(params[:resto_id])
    respond_with(@schedule)
  end
  
  def create
    @schedule = Schedule.new(schedule_params)
    @schedule.restaurant = current_user.restaurants.find(params[:resto_id])
    if @schedule.save
      flash[:success] = "Schedule successfully added!"
      @schedules = @schedule.restaurant.schedules
      respond_with(@schedules)
    else
      flash[:failure] = "<dl><dt>Your schedule was not successfully added because:</dt>" 
      @schedule.errors.full_messages.map { |msg| flash[:failure] << "<dd>#{msg}</dd>" }
      flash[:failure] << "</dl>"
      respond_with(@schedule)
    end
  end
  
  def edit
  end
  
  def update
    if @schedule.update(schedule_params)
      flash[:success] = "Schedule successfully updated!"
      respond_with(@schedule, location: owner_resto_edit_path(@schedule.restaurant))
    else
      flash[:failure] = "<dl><dt>Your schedule was not successfully updated because:</dt>" 
      @schedule.errors.full_messages.map { |msg| flash[:failure] << "<dd>#{msg}</dd>" }
      flash[:failure] << "</dl>"
      redirect_to owner_resto_edit_path(@schedule.restaurant)
    end
  end
  
  def destroy
    if @schedule.destroy
      flash[:success] = 'Schedule successfully deleted!'
      respond_with(@schedule, location: owner_resto_edit_path(@schedule.restaurant))
    else
      flash[:failure] = "<dl><dt>Your schedule was not successfully added because:</dt>" 
      @schedule.errors.full_messages.map { |msg| flash[:failure] << "<dd>#{msg}</dd>" }
      flash[:failure] << "</dl>"
      redirect_to owner_resto_edit_path(@schedule.restaurant)
    end
  end
  
  private

  def set_schedule
    @schedule = Schedule.find(params[:id])  
  end
  
  def schedule_params
    params.require(:schedule).permit(:day, :opening, :closing)    
  end
  
end  