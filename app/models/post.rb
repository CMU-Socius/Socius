class Post < ActiveRecord::Base

	# get module to help with some functionality
  include SociusWebHomelessHelpers::Validations

    self.per_page = 10
	
	#Relationships

	
	belongs_to :poster, class_name: :User, foreign_key: :poster_id
	belongs_to :claimer, class_name: :User, foreign_key: :claimer_id
	has_many :post_needs
	has_many :needs, through: :post_needs

	#Virtual Attributes
	attr_accessor :need_name
	
	# get an array of the states in U.S.
    STATES_LIST = [['Alabama', 'AL'],['Alaska', 'AK'],['Arizona', 'AZ'],['Arkansas', 'AR'],['California', 'CA'],['Colorado', 'CO'],['Connectict', 'CT'],['Delaware', 'DE'],['District of Columbia ', 'DC'],['Florida', 'FL'],['Georgia', 'GA'],['Hawaii', 'HI'],['Idaho', 'ID'],['Illinois', 'IL'],['Indiana', 'IN'],['Iowa', 'IA'],['Kansas', 'KS'],['Kentucky', 'KY'],['Louisiana', 'LA'],['Maine', 'ME'],['Maryland', 'MD'],['Massachusetts', 'MA'],['Michigan', 'MI'],['Minnesota', 'MN'],['Mississippi', 'MS'],['Missouri', 'MO'],['Montana', 'MT'],['Nebraska', 'NE'],['Nevada', 'NV'],['New Hampshire', 'NH'],['New Jersey', 'NJ'],['New Mexico', 'NM'],['New York', 'NY'],['North Carolina','NC'],['North Dakota', 'ND'],['Ohio', 'OH'],['Oklahoma', 'OK'],['Oregon', 'OR'],['Pennsylvania', 'PA'],['Rhode Island', 'RI'],['South Carolina', 'SC'],['South Dakota', 'SD'],['Tennessee', 'TN'],['Texas', 'TX'],['Utah', 'UT'],['Vermont', 'VT'],['Virginia', 'VA'],['Washington', 'WA'],['West Virginia', 'WV'],['Wisconsin ', 'WI'],['Wyoming', 'WY']].freeze

	#Scope
	scope :chronological, -> { order(date_posted: :desc) }
	scope :incomplete,    -> { where(date_completed: nil)}
	scope :completed,     -> { where.not(date_completed: nil)}
	scope :posted_by,   -> (poster) { where(poster_id: poster.id) }
	scope :claimed_by,   -> (claimer) { where(claimer_id: claimer.id) }
	scope :for_organization, ->(organization_id) {joins(:poster).where('organization_id = ?',organization_id )}
	scope :not_cancelled, ->{where(date_cancelled: nil)}



	# Validations
	validates_presence_of :street_1, :number_people, :poster_id
	validates_numericality_of :poster_id, only_integer: true
	validates_numericality_of :claimer_id, only_integer: true, allow_blank: true
	validates_numericality_of :number_people, only_integer: true, greater_than: 0, message: "should be an integer"
	validates_format_of :zip, with: /\A\d{5}\z/, message: "should be five digits long"
	validates_inclusion_of :state, in: STATES_LIST.map{|key, value| value}, message: "is not an option"
	validates_inclusion_of :state, in: STATES_LIST.to_h.values, message: "is not an option"
    validates_datetime :date_posted, on_or_before: lambda { DateTime.current }, allow_blank: true
    validates_datetime :date_completed, on_or_after: :date_posted, allow_blank: true
    validate :address_is_valid, on:  :create

	#Callbacks
	before_create :set_datetime_posted_if_not_given
	#Gecoding
	geocoded_by :full_street_address
	after_validation :geocode

	#Methods
	def complete
		self.date_completed = DateTime.current
		self.save!
	end

	def update_post_needs(new_completed_ids)
		completed_ids = new_completed_ids.select{ |id| id != '' }.map { |id| id.to_i }
		self.post_needs.each do |pn|
			if completed_ids.include? pn.id
				pn.complete
			else
				pn.undo_complete
			end
		end
	end

	def post_needs
		PostNeed.where(post_id: self.id)
	end

	def poster_name
		self.poster_id ? User.find(self.poster_id).proper_name : nil
	end

	def claimer_name
		self.claimer_id ? User.find(self.claimer_id).proper_name : nil
	end

	def self.get_post_details(posts)
		# post_needs = posts.map { |p| p.post_needs.to_a }
		# posters = posts.map { |p| p.poster_id ? User.find(p.poster_id) : nil }
		# claimers = posts.map { |p| p.claimer_id ? User.find(p.claimer_id) : nil }
		# post_details = posts.zip(post_needs, posters, claimers)
		post_details = posts.map { |p| {
			"id" => p.id, 
			"poster_id" => p.poster_id, 
			"poster_name" => p.poster_id ? User.find(p.poster_id).proper_name : nil,
			"created_at" => p.created_at, 
			"street_1" => p.street_1,
			"street_2" => p.street_2,
			"city" => p.city,
			"state" => p.state,
			"zip" => p.zip, 
			"lat" => p.latitude, 
			"lng" => p.longitude, 
			"claimer_id" => p.claimer_id, 
			"claimer_name" => p.claimer_id ? User.find(p.claimer_id).proper_name : nil,
			"date_cancelled" => p.date_cancelled,
			"date_claimed" => p.date_claimed,
			"date_completed" => p.date_completed,
		}}
	end

	#Methods for analytics
	#all posts in the same location

	def claimed_by(user_id)
		if self.claimer_id.nil?
			self.claimer_id = user_id
			self.date_cancelled = nil
			self.date_claimed = Date.current
			self.save!
		else
			false
		end
    end

    def all_completed?
		self.post_needs.each do |n|
				if !n.complete? 
					return false
				end
	    end
	    return true

    end

	def unclaim
		if !self.claimer_id.nil?
			self.claimer_id = nil
			self.date_claimed = nil
			self.save!
		else
			false
		end
	end

	def cancel
		if self.date_cancelled.nil?
			self.date_cancelled = Date.current
			self.claimer_id = nil
			self.date_claimed = nil
			self.save!
		else
			false
		end
	end


	def full_street_address
		if self.street_2.nil?
			"#{self.street_1}, #{self.city}, #{self.state} #{self.zip}"
		else
			"#{self.street_1}, #{self.street_2}, #{self.city}, #{self.state} #{self.zip}"
		end
	end

	def set_datetime_posted_if_not_given
		 #TO DO: make this account for non date inputs as well
    if self.date_posted.nil?
      self.date_posted = DateTime.current
    end
  end
  
  def address_is_valid
		return true if Geocoder.coordinates(self.full_street_address)
		self.errors.add(:city, "Address was not found.")
	end
end

