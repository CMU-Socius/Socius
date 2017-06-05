class Need < ActiveRecord::Base
	#Relationships
	has_many :post_needs
	has_many :posts, through :post_needs
end
