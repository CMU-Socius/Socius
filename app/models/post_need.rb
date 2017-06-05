class PostNeed < ActiveRecord::Base
	#Relationships
	belongs_to :needs
	belongs_to :posts
end
