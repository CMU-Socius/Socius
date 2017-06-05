class Post < ActiveRecord::Base
	#Relationships
  has_many :user_posts
  has_many :posts, through :user_posts
  has_many :post_needs
  has_many :needs, through :post_needs
end
