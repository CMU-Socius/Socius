class Need < ActiveRecord::Base
	include SociusWebHomelessHelpers::Validations

	CATEGORIES = [['Food', :food],['Clothing', :clothing],['Toiletries', :toiletries],['Camp Supplies', :camp], ['Transportation', :transportation], ['Medical Supplies', :medical],['Other', :other]]

	#Relationships
	has_many :post_needs

	#Scopes
	scope :alphabetical,  -> { order(:name) }
	scope :for_need,    ->(need) { where(name: need) }
	scope :of_category,    ->(category) { where(category: category) }

	#Validations
	validates :name, presence: true, uniqueness: { case_sensitive: false}
	validates :category, inclusion: { in: CATEGORIES.map { |c| c[1].to_s }, message: "is not a recognized category in system" }

	#Callbacks
	before_destroy :is_never_destroyable
	before_save :reformat_name
	
	def self.by_category
		needs = Hash.new
		CATEGORIES.each do |c|
			category_needs = Need.of_category(c)
			unless category_needs.empty?
				needs[c[0]] = Need.of_category(c).alphabetical.to_a
			end
		end
		needs
	end

	private
	def reformat_name
		name = self.name.to_s  #in case not string input
		self.name = name.capitalize    # reset self.name to new string
  end



end
