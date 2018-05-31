class Alliance < ActiveRecord::Base
	has_many :org_alliances
	has_many :organizations, :through => :org_alliances

	#Scopes
	scope :alphabetical,  -> { order(:name) }

	def org_choices
		choices = Array.new()
		Organization.all.each do |o|
			if !self.organizations.include?(o)
				choices.push([o.name,o.id])
			end
		end
		return choices
	end

	def all_org_ids
		ids = Array.new()
		self.organizations.each do |o|
			ids.push(o.id)
		end
		return ids
	end


end
