class SchedulesController < ApplicationController
  before_action :set_schedule, only: [:edit, :update, :destroy]
  respond_to :html
  respond_to :js, only: [:new, :edit, :create, :destroy, :update]

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
      @schedules = @schedule.restaurant.schedules
      if Schedule.check_overlapping?(@schedule, @schedule.restaurant)
        
      else
        @schedule.destroy
        if Schedule.check_time?(schedule_params[:opening], schedule_params[:closing])
          @err = "<dd>#{t('.openingerror')}</dd>"
        else
          @err = "<dd>#{t('.overlapping')}</dd>"
        end
      end
      @schedules = @schedule.restaurant.schedules.page params[:page]
      respond_with(@schedules)
    else
      @schedules = @schedule.restaurant.schedules.page params[:page]
      respond_with(@schedule)
    end
  end
  
  def edit
    @days = []
    Date::DAYNAMES.each_with_index { |x, i| @days << [x, x] }
  end
  
  def update
    sched = @schedule
    sched_attributes = @schedule.attributes
    if @schedule.update(schedule_params) && Schedule.check_overlapping?(@schedule, @schedule.restaurant)
      flash[:success] = t('.success')
      @schedules = @schedule.restaurant.schedules.page params[:page]
      respond_with(@schedules)
    else
      @schedule.update(sched_attributes)
      if Schedule.check_overlapping?(sched, sched.restaurant)
        @err = t('.overlapping')
      end
    end
  end
  
  def destroy
    if @schedule.destroy
      @schedules = @schedule.restaurant.schedules.page params[:page]
      respond_with(@schedules)
    else
      flash[:failure] = "<dl><dt>#{t('.failurestart')}</dt>" 
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