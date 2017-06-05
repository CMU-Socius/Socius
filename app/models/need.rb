class Need < ActiveRecord::Base
	#Relationships
	has_many :post_needs

	#Scopes
	scope :alphabetical,  -> { order(:name) }
	scope :for_need,    ->(need) { where(name: need) }

	#Validations
	validates_presence_of :name

	#Methods
	#automatically capitalize first letter of need


end
