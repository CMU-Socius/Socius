class Organization < ActiveRecord::Base
	#Relationships
	has_many :users

	#Validations
	validates_presence_of :name
	validate :organization_is_not_a_duplicate, on: :create

	#Scopes
	scope :alphabetical,  -> { order(:name) }
	scope :active,        -> { where(active: true) }
  scope :inactive,      -> { where(active: false) }

	def already_exists?
  	Organization.where(name: self.name).size == 1
  end

	
	private
	
	def organization_is_not_a_duplicate
		return true if self.name.nil? 
		if self.already_exists?
			errors.add(:name, "already exists for this organization")
		end
	end

end
