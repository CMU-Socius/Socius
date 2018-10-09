class Camp < ActiveRecord::Base
	has_many :camp_orgs
	has_many :organizations, :through => :camp_orgs
	has_many :posts

	self.per_page = 10

	STATES_LIST = [['Alabama', 'AL'],['Alaska', 'AK'],['Arizona', 'AZ'],['Arkansas', 'AR'],['California', 'CA'],['Colorado', 'CO'],['Connectict', 'CT'],['Delaware', 'DE'],['District of Columbia ', 'DC'],['Florida', 'FL'],['Georgia', 'GA'],['Hawaii', 'HI'],['Idaho', 'ID'],['Illinois', 'IL'],['Indiana', 'IN'],['Iowa', 'IA'],['Kansas', 'KS'],['Kentucky', 'KY'],['Louisiana', 'LA'],['Maine', 'ME'],['Maryland', 'MD'],['Massachusetts', 'MA'],['Michigan', 'MI'],['Minnesota', 'MN'],['Mississippi', 'MS'],['Missouri', 'MO'],['Montana', 'MT'],['Nebraska', 'NE'],['Nevada', 'NV'],['New Hampshire', 'NH'],['New Jersey', 'NJ'],['New Mexico', 'NM'],['New York', 'NY'],['North Carolina','NC'],['North Dakota', 'ND'],['Ohio', 'OH'],['Oklahoma', 'OK'],['Oregon', 'OR'],['Pennsylvania', 'PA'],['Rhode Island', 'RI'],['South Carolina', 'SC'],['South Dakota', 'SD'],['Tennessee', 'TN'],['Texas', 'TX'],['Utah', 'UT'],['Vermont', 'VT'],['Virginia', 'VA'],['Washington', 'WA'],['West Virginia', 'WV'],['Wisconsin ', 'WI'],['Wyoming', 'WY']].freeze
    

	validates_presence_of :name, :street_1
	validates_format_of :zip, with: /\A\d{5}\z/, message: "should be five digits long"
	validates_inclusion_of :state, in: STATES_LIST.map{|key, value| value}, message: "is not an option"
	validates_inclusion_of :state, in: STATES_LIST.to_h.values, message: "is not an option"
    validate :address_is_valid, on:  :create
    validate :area_is_valid

    scope :active,    -> { where(active: true)}
    scope :has_area, ->{where.not(lat: nil)}



    geocoded_by :full_street_address
	after_validation :geocode


	before_destroy do 
	    self.posts.each{|p| p.camp_id = nil}
	end


    def full_street_address
		if self.street_2.nil?
			"#{self.street_1}, #{self.city}, #{self.state} #{self.zip}"
		else
			"#{self.street_1}, #{self.street_2}, #{self.city}, #{self.state} #{self.zip}"
		end
	end

    def address_is_valid
		return true if Geocoder.coordinates(self.full_street_address)
		self.errors.add(:city, "Address was not found.")
	end

	def all_org_ids
		ids = Array.new()
		self.organizations.each do |o|
			ids.push(o.id)
		end
		return ids
	end

	def self.all_belong_to(org_id)
		result = []
		Camp.all.each do |c|
			if c.all_org_ids.include?(org_id)
				result.push(c)
			end
		end
		return result
	end

	def can_see(organization_id,admin=false)
		return true if admin
		self.all_org_ids.include?(organization_id)
	end

	def self.get_camp_details(camps,organization_id = nil)
		# post_needs = posts.map { |p| p.post_needs.to_a }
		# posters = posts.map { |p| p.poster_id ? User.find(p.poster_id) : nil }
		# claimers = posts.map { |p| p.claimer_id ? User.find(p.claimer_id) : nil }
		# post_details = posts.zip(post_needs, posters, claimers)
		# if(!organization_id.nil?){
		# 	puts(camps.select{ |c|  c.can_see(organization_id)  } )
		# }
		camp_details = camps.map { |p| {
			"id" => p.id, 
			"name" => p.name,
			"street_1" => p.street_1,
			"street_2" => p.street_2,
			"city" => p.city,
			"state" => p.state,
			"zip" => p.zip, 
			"lat" => p.latitude, 
			"lng" => p.longitude,
			"lats" => p.lat,
			"longs" => p.long
		}}
	end

	def org_choices
		choices = Array.new()
		Organization.alphabetical.each do |o|
			if !self.organizations.include?(o)
				choices.push([o.name,o.id])
			end
		end
		return choices
	end

	def all_org_names
		self.organizations.map(&:name).join(", ")
	end
	


	def area_is_valid
		return true if self.lat.nil?
		if self.lat.split(",").size <3 or self.long.split(",").size <3
			self.errors.add(:camp,"area is not valid.")
			return false
		end
		return true
	end
end
