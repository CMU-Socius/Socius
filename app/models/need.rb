class Need < ActiveRecord::Base
	#Relationships
	has_many :post_needs

	#Scopes
	scope :alphabetical,  -> { order(:name) }

	#Validations
	validates_presence_of :name
end
