class Schedule < ActiveRecord::Base
  belongs_to :restaurant
  
  validates :restaurant, :day, :opening, :closing, presence: true
  
  def self.check_time?(opening, closing)   
    if Time.parse(opening).to_i >= Time.parse(closing).to_i
      return true
    end
    return false
  end
  
  def self.check_overlapping?(record, resto)    
    return false if Schedule.check_time?(record.opening, record.closing)

    day_checker = Schedule.where(day: record.day, restaurant: resto).where.not(id: record.id).sort{ |a,b| Time.parse(a.closing) <=> Time.parse(b.closing) }
    
    parse_test_opening = Time.parse(record.opening)
    parse_test_closing = Time.parse(record.closing)
    
    time_test_opening = parse_test_opening.to_a
    time_test_closing= parse_test_closing.to_a
    exceptions = ['id', 'created_at', 'updated_at']
    
    unless day_checker.nil?
      day_checker.each do |sched|
        parse_opening = Time.parse(sched.opening)
        parse_closing = Time.parse(sched.closing)
        
        opening = parse_opening.to_a
        closing = parse_closing.to_a
        if (time_test_opening[2]..time_test_closing[2]).overlaps? (opening[2]..closing[2])
          #there is an existing record with same values
          return false if sched.attributes.except(*exceptions) == record.attributes.except(*exceptions)
          #overlap with the opening time of a recorded sched
          if time_test_closing[2] == opening[2] && time_test_closing[1] == opening[1]     
            return false unless opening[1] >= time_test_closing[1]
          #overlap with the closing time of a record sched
          elsif time_test_opening[2] == closing[2] && time_test_opening[1] == closing[1]
            return false unless closing[1] <= time_test_opening[1]
          else
            return false if (parse_opening+1.minutes...parse_closing).overlaps? (parse_test_opening..parse_test_closing)
            unless day_checker.last == sched
              next
            end 
          end
        else
          unless day_checker.last == sched
            next
          end
          return true     
        end
        
      end
    end
    return true
  end
  
end
