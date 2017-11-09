class Alliance < ActiveRecord::Base
	has_many :users

	#Scopes
	scope :alphabetical,  -> { order(:name) }
end
