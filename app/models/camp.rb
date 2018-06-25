class Camp < ActiveRecord::Base
	has_many :camp_orgs
	has_many :organizations, through: :camp_orgs
	has_many :posts

	STATES_LIST = [['Alabama', 'AL'],['Alaska', 'AK'],['Arizona', 'AZ'],['Arkansas', 'AR'],['California', 'CA'],['Colorado', 'CO'],['Connectict', 'CT'],['Delaware', 'DE'],['District of Columbia ', 'DC'],['Florida', 'FL'],['Georgia', 'GA'],['Hawaii', 'HI'],['Idaho', 'ID'],['Illinois', 'IL'],['Indiana', 'IN'],['Iowa', 'IA'],['Kansas', 'KS'],['Kentucky', 'KY'],['Louisiana', 'LA'],['Maine', 'ME'],['Maryland', 'MD'],['Massachusetts', 'MA'],['Michigan', 'MI'],['Minnesota', 'MN'],['Mississippi', 'MS'],['Missouri', 'MO'],['Montana', 'MT'],['Nebraska', 'NE'],['Nevada', 'NV'],['New Hampshire', 'NH'],['New Jersey', 'NJ'],['New Mexico', 'NM'],['New York', 'NY'],['North Carolina','NC'],['North Dakota', 'ND'],['Ohio', 'OH'],['Oklahoma', 'OK'],['Oregon', 'OR'],['Pennsylvania', 'PA'],['Rhode Island', 'RI'],['South Carolina', 'SC'],['South Dakota', 'SD'],['Tennessee', 'TN'],['Texas', 'TX'],['Utah', 'UT'],['Vermont', 'VT'],['Virginia', 'VA'],['Washington', 'WA'],['West Virginia', 'WV'],['Wisconsin ', 'WI'],['Wyoming', 'WY']].freeze
    

	validates_presence_of :name, :street_1
	validates_format_of :zip, with: /\A\d{5}\z/, message: "should be five digits long"
	validates_inclusion_of :state, in: STATES_LIST.map{|key, value| value}, message: "is not an option"
	validates_inclusion_of :state, in: STATES_LIST.to_h.values, message: "is not an option"
    validate :address_is_valid, on:  :create
    validate :area_is_valid



    geocoded_by :full_street_address
	after_validation :geocode


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

	def self.get_camp_details(camps)
		# post_needs = posts.map { |p| p.post_needs.to_a }
		# posters = posts.map { |p| p.poster_id ? User.find(p.poster_id) : nil }
		# claimers = posts.map { |p| p.claimer_id ? User.find(p.claimer_id) : nil }
		# post_details = posts.zip(post_needs, posters, claimers)
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
	


	def area_is_valid
		return true if self.lat.split(",").size == 0 and self.long.split(",").size == 0
		if self.lat.split(",").size <3 or self.long.split(",").size <3
			self.errors.add(:camp,"area is not valid.")
			return false
		end
		return true
	end
end
