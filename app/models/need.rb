class Need < ActiveRecord::Base
	include SociusWebHomelessHelpers::Validations

	CATEGORIES = [['Food', :food],['Clothing', :clothing],['Toiletries', :toiletries],['Camp Supplies', :camp], ['Transportation', :transportation], ['Medical Supplies', :medical],['Other', :other]]

	#Relationships
	has_many :post_needs

	#Scopes
	scope :alphabetical,  -> { order(:name) }
	scope :for_need,    ->(need) { where(name: need) }

	#Validations
	validates :name, presence: true, uniqueness: { case_sensitive: false}
	validates :category, inclusion: { in: CATEGORIES.map { |c| c[1].to_s }, message: "is not a recognized category in system" }

	#Callbacks
	before_destroy :is_never_destroyable
	before_save :reformat_name
	

	private
	def reformat_name
		name = self.name.to_s  #in case not string input
		self.name = name.capitalize    # reset self.name to new string
  end



end
