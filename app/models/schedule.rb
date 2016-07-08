class Schedule < ActiveRecord::Base
  belongs_to :restaurant
  
  validates :restaurant, :day, :opening, :closing, presence: true
  
  def self.check_overlapping?(parameters)
    
    day_checker = Schedule.where(day: parameters[:day])
    time_test_opening = Time.parse(parameters[:opening])
    time_test_closing = Time.parse(parameters[:closing])
    
    unless day_checker.nil?
      day_checker.each do |sched|
        opening = Time.parse(sched.opening)
        closing = Time.parse(sched.closing)
        return false if (opening..closing).overlaps? (time_test_opening..time_test_closing)
      end
    end 
    return true
  end
end
