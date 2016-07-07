class Restaurant < ActiveRecord::Base
  mount_uploader :avatar, AvatarUploader
  mount_uploader :cover, AvatarUploader
  
  belongs_to :user
  has_many :ratings, dependent: :destroy
  has_many :foods, dependent: :destroy
  has_many :pictures, dependent: :destroy
  has_many :schedules, dependent: :destroy
  has_many :cuisines, through: :foods
  has_one :location
  validates :name, :description, :address, :contact, :user, presence: true

  def ave_ratings
    unless ratings.empty?
      ratings.collect(&:rate).sum.to_f/ratings.size 
    else
      0
    end
  end
  
  def sched
    scheds = schedules.group_by{|s| [s.opening, s.closing]}
    @hours = ""
    scheds.each do |key,value| 
      @all_day = []
      value.each do |val|
        @all_day << val.day unless @all_day.include? val.day
      end
      days = []
      @all_day.uniq.each do |day|
        days << DateTime.parse(day).wday
      end
      
      days.each_with_index do |val, index|
        index + 1 < days.count ? upper = days[index+1] : upper = val+1
        if val != 0 && val+1 != upper
          days.insert(index+1, 0)    
        end
      end
      days = days.split(0)
      days.each do |day|
        if day.first != day.last
          @hours << "#{key[0]} - #{key[1]} (#{Date::ABBR_DAYNAMES[day.first]} - #{Date::ABBR_DAYNAMES[day.last]}) "
        else
          if days.count == 1
            @hours << "#{key[0]} - #{key[1]} #{Date::ABBR_DAYNAMES[day.first]} "
          else
            @hours << ", #{Date::ABBR_DAYNAMES[day.first]} "
          end
        end
      end
    end
    return @hours
  end
  
  def min_price
    foods.minimum(:price).to_i
  end
  
  def max_price
    foods.maximum(:price).to_i
  end
  
  def hours
    
  end
  
  def self.search_by_name(query)
    Restaurant.where("name LIKE ?","%#{query}%").map(&:id)
  end
end
