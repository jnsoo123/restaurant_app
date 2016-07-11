class Schedule < ActiveRecord::Base
  belongs_to :restaurant
  
  validates :restaurant, :day, :opening, :closing, presence: true
  
  def self.check_overlapping?(parameters, resto)    
    day_checker = Schedule.where(day: parameters[:day], restaurant: resto)
    
    time_test_opening = Time.parse(parameters[:opening])
    time_test_closing = Time.parse(parameters[:closing])
    time_test_closing = time_test_closing + 24.hours if Time.at(time_test_opening.to_i) > (Time.at(time_test_closing.to_i))
              
    unless day_checker.nil?
      day_checker.each do |sched|
        opening = Time.parse(sched.opening)
        closing = Time.parse(sched.closing)
        closing = closing + 24.hours if Time.at(opening.to_i) > (Time.at(closing.to_i))

        return false if (opening..closing).overlaps? (time_test_opening..time_test_closing)
      end
    end 
    return true
  end
end
