class Restaurant < ActiveRecord::Base
  belongs_to :user
  has_many :ratings
  
  validates :name, presence: true
  validates :description, presence: true
  validates :address, presence: true
  validates :contact, presence: true
end
