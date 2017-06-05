class Organization < ActiveRecord::Base
	#Relationships
	has_many :users
end
