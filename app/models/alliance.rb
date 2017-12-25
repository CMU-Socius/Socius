class Alliance < ActiveRecord::Base
	has_many :users

	#Scopes
	scope :alphabetical,  -> { order(:name) }

	def organizations
  	Organization.where(alliance_id: self.id)
  end
end
