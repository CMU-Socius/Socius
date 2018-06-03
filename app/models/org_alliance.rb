class OrgAlliance < ActiveRecord::Base
	belongs_to :organization
	belongs_to :alliance


	validates :organization_id, presence: true
	validates :alliance_id, presence: true

end
