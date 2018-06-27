class CampOrg < ActiveRecord::Base
	belongs_to :organization
	belongs_to :camp
end
