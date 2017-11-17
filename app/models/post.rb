class Post < ActiveRecord::Base

	# get module to help with some functionality
  include SociusWebHomelessHelpers::Validations
	
	#Relationships

	
	belongs_to :poster, class_name: :User, foreign_key: :poster_id
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


	# Validations
	validates_presence_of :street_1, :number_people, :poster_id
	validates_numericality_of :poster_id, only_integer: true
	validates_numericality_of :claimer_id, only_integer: true, allow_blank: true
	validates_numericality_of :number_people, only_integer: true, greater_than: 0
	validates_format_of :zip, with: /\A\d{5}\z/, message: "should be five digits long"
	validates_inclusion_of :state, in: STATES_LIST.map{|key, value| value}, message: "is not an option"
	validates_inclusion_of :state, in: STATES_LIST.to_h.values, message: "is not an option"
  validates_datetime :date_posted, on_or_before: lambda { DateTime.current }, allow_blank: true
  validates_datetime :date_completed, on_or_after: :date_posted, allow_blank: true
	# validate :poster_is_active_in_system

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

	def post_needs
		PostNeed.where(post_id: self.id)
	end

	def self.get_post_details(posts)
		post_needs = posts.map { |p| p.post_needs.to_a }
		posters = posts.map { |p| p.poster_id ? User.find(p.poster_id) : nil }
		claimers = posts.map { |p| p.claimer_id ? User.find(p.claimer_id) : nil }
		post_details = posts.zip(post_needs, posters, claimers)
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


	private
	def poster_is_active_in_system
		return true if self.poster.nil?
		all_active = User.active.to_a.map{|u| u.id}
		unless all_active.include?(self.poster.id)
        self.errors.add(self.poster.proper_name, " is not active in the system")
      end
		true
  end

	 def set_datetime_posted_if_not_given
		 #TO DO: make this account for non date inputs as well
    unless !self.date_posted.nil?
      self.date_posted = DateTime.current
    end
  end







end

