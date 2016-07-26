class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  validates :name, :username, presence: true
  validates_length_of :name, minimum: 6
  validates :username, uniqueness: true
  validates_format_of :avatar, with: %r{\.(gif|jpg|png|jpeg)\Z}i, allow_blank: true, on: :update, if: :avatar_check?
  validates_format_of :username, without: %r{[\s-]}
  after_destroy :ensure_an_admin_remains
  mount_uploader :avatar, AvatarUploader
  has_many :restaurants, dependent: :destroy
  has_many :ratings, dependent: :destroy
  has_many :pictures, dependent: :destroy
  has_many :notifications, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :replies, dependent: :destroy
  
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable, :omniauth_providers => [:facebook]
  
  def avatar_check?
    avatar.nil? || avatar.present? 
  end
  
  def check_notification
    if notifications.where(status: false).count > 0
      "<span class='label label-danger' style='margin-left: 10px;'>New</span>"
    end
  end
  
  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0,20]
      user.username = auth.info.name.split(' ').join('').downcase
      user.name = auth.info.name  # assuming the user model has a name
      user.remote_avatar_url = auth.info.image.gsub('http://','https://')
      puts "@@@@@@@####### @@@@@@@@####### #{user.name}"
      puts "@@@@@@@####### @@@@@@@@####### #{auth.info.image}"
      puts "@@@@@@@####### @@@@@@@@####### #{user.remote_avatar_url}"
    end
  end
  
  def self.new_with_session(params, session)
    super.tap do |user|
      if data = session["devise.facebook_data"] && session["devise.facebook_data"]["extra"]["raw_info"]
        user.email = data["email"] if user.email.blank?
      end
    end
  end
  
  private
  
  def ensure_an_admin_remains
    if User.where(admin: true).count.zero?
      raise "Can't delete last admin"
    end
  end
end
