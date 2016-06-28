class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable

  validates :name, :username, presence: true
  validates :username, uniqueness: true
  
  mount_uploader :avatar, AvatarUploader
  has_many :restaurants, dependent: :destroy
  has_many :ratings
  has_many :pictures
  has_many :notifications
  
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  
  def check_notification
    if notifications.where(status: false).count > 0
      "<span class='label label-danger' style='margin-left: 10px;'>New</span>"
    end
  end
  
end
