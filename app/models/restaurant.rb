class Restaurant < ActiveRecord::Base
  belongs_to :user
  has_many :ratings
  has_many :foods
  
  validates :name, presence: true
  validates :description, presence: true
  validates :address, presence: true
  validates :contact, presence: true
  
  def avg_ratings
    #func for avg ratings
  end
end
