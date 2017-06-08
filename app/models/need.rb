class Need < ActiveRecord::Base
	include SociusWebHomelessHelpers::Validations
	#Relationships
	has_many :post_needs

	#Scopes
	scope :alphabetical,  -> { order(:name) }
	scope :for_need,    ->(need) { where(name: need) }

	#Validations
	validates :name, presence: true, uniqueness: { case_sensitive: false}

	#Callbacks
	before_destroy :is_never_destroyable
	before_save :reformat_name
	

	private
	def reformat_name
		name = self.name.to_s  #in case not string input
		self.name = name.capitalize    # reset self.name to new string
  	end



end
