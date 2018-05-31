class Organization < ActiveRecord::Base
	#Relationships
	has_many :users
	belongs_to :alliance
	has_many :org_alliances
	has_many :alliances, through: :org_alliances

	#Validations
	validates :name, presence: true, uniqueness: { case_sensitive: false}
	validate :organization_is_not_a_duplicate, on: :create

	#Scopes
	scope :alphabetical,  -> { order(:name) }
	scope :active,        -> { where(active: true) }
    scope :inactive,      -> { where(active: false) }

	def already_exists?
  	  Organization.where(name: self.name).size > 0
    end

    def users
  	  User.where(organization_id: self.id)
    end

    def all_user_ids
      return self.users.map(&:id)
    end

    def all_alliance_ids
    	return self.alliances.map(&:id)
    end


	
	private
	
	def organization_is_not_a_duplicate
		return true if self.name.nil? 
		if self.already_exists?
			self.errors.add(:name, "already exists for this organization")
		end
	end

end
