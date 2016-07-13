class Restaurant < ActiveRecord::Base
  mount_uploader :avatar, AvatarUploader
  mount_uploader :cover, AvatarUploader
  
  belongs_to :user
  has_many :ratings, dependent: :destroy
  has_many :foods, dependent: :destroy
  has_many :pictures, dependent: :destroy
  has_many :schedules, dependent: :destroy
  has_many :cuisines, through: :foods
  has_many :posts, dependent: :destroy
  has_one :location, dependent: :destroy
  validates :name, :contact, :user, presence: true

  def ave_ratings
    unless ratings.empty?
      ratings.collect(&:rate).sum.to_f/ratings.size 
    else
      0
    end
  end
  
  def is_open?(current)
    scheds = schedules.group_by{|s| [s.day]}
    @hours = ""

    mappings = {["Sunday"] => 0, ["Monday"] => 1, ["Tuesday"] => 2, ["Wednesday"] => 3, ["Thursday"] => 4, ["Friday"] => 5, ["Saturday"] => 6}
    scheds = scheds.map {|k, v| [mappings[k], v] }.to_h

    scheds = scheds.sort_by{ |k,v| k }.to_h

    today_time = current.to_time.to_a
    scheds.each do |key, value|
      if current.wday == key
        value.each do |val|
          open_time = Time.parse(val.opening).to_a
          close_time = Time.parse(val.closing).to_a

          close_time[2] = close_time[2] + 24 if Time.at(Time.parse(val.opening).to_i) > (Time.at(Time.parse(val.closing).to_i))

          if (open_time[2]..close_time[2]).cover? today_time[2]
            if today_time[2] == close_time[2]
              return true if ((0..close_time[1]).cover? today_time[1])
            elsif today_time[2] == open_time[2]
              return true if ((open_time[1]..59).cover? today_time[1])
            else
              return true
            end
          end
        end
      end
    end
    return false
  end
  
  def sched
    scheds = schedules.group_by{|s| [s.day]}
    @hours = ""

    mappings = {["Sunday"] => 0, ["Monday"] => 1, ["Tuesday"] => 2, ["Wednesday"] => 3, ["Thursday"] => 4, ["Friday"] => 5, ["Saturday"] => 6}
    scheds = scheds.map {|k, v| [mappings[k], v] }.to_h
    scheds = scheds.sort_by{ |k,v| k }.to_h
    scheds.each do |key, value|
      @hours << "#{Date::DAYNAMES[key]} "
      value.each_with_index do |val, index|
        if value.count > 1 && index < value.count-1
          @hours << "#{val.opening} - #{val.closing}, "
        else
          @hours << "#{val.opening} - #{val.closing} "
        end
      end
    end
    return scheds
  end
  
  def min_price
    foods.minimum(:price).to_i
  end
  
  def max_price
    foods.maximum(:price).to_i
  end
  
  def self.search_by_name(query)
    Restaurant.where("name LIKE ?","%#{query}%").map(&:id)
  end
end
