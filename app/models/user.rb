class User < ActiveRecord::Base
  #Relationships
	belongs_to :organizations
  has_many :user_posts
	has_many :posts, through :user_posts

end
