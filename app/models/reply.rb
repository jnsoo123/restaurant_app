class Reply < ActiveRecord::Base
  belongs_to :user
  belongs_to :rating
  belongs_to :post
  
end
