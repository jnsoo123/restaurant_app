class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable

  validates :name, :email, :username, presence: true
  validates :email, :username, uniqueness: true
  
  mount_uploader :avatar, AvatarUploader
  has_many :restaurants, dependent: :destroy
  has_many :ratings
  has_many :pictures
  
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  
  
end
