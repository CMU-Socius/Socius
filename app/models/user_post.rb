class UserPost < ActiveRecord::Base
	#Relationships
	belongs_to :user
  belongs_to :post
end
