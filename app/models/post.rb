class Post < ActiveRecord::Base

	# get module to help with some functionality
  include SociusWebHomelessHelpers::Validations


    self.per_page = 10

    STATUS = [['Requests posted below', 'requests'],['Camp is abandoned', 'abandoned'],['Occupied but no one is home', 'noone'],['Individuals met but no requests', 'met'], ['Other (Specified in the comment box)', 'other']]
	
	#Relationships

	
	belongs_to :poster, class_name: :User, foreign_key: :poster_id
	has_many :post_claims
	has_many :claimers, through: :post_claims
	has_many :post_needs
	has_many :needs, through: :post_needs
	has_many :sharings
	has_many :alliances,through: :sharings
	has_many :comments


	accepts_nested_attributes_for :comments, :reject_if => lambda { |a| a[:content].blank? }

	#Virtual Attributes
	attr_accessor :need_name
	
	# get an array of the states in U.S.
    STATES_LIST = [['Alabama', 'AL'],['Alaska', 'AK'],['Arizona', 'AZ'],['Arkansas', 'AR'],['California', 'CA'],['Colorado', 'CO'],['Connectict', 'CT'],['Delaware', 'DE'],['District of Columbia ', 'DC'],['Florida', 'FL'],['Georgia', 'GA'],['Hawaii', 'HI'],['Idaho', 'ID'],['Illinois', 'IL'],['Indiana', 'IN'],['Iowa', 'IA'],['Kansas', 'KS'],['Kentucky', 'KY'],['Louisiana', 'LA'],['Maine', 'ME'],['Maryland', 'MD'],['Massachusetts', 'MA'],['Michigan', 'MI'],['Minnesota', 'MN'],['Mississippi', 'MS'],['Missouri', 'MO'],['Montana', 'MT'],['Nebraska', 'NE'],['Nevada', 'NV'],['New Hampshire', 'NH'],['New Jersey', 'NJ'],['New Mexico', 'NM'],['New York', 'NY'],['North Carolina','NC'],['North Dakota', 'ND'],['Ohio', 'OH'],['Oklahoma', 'OK'],['Oregon', 'OR'],['Pennsylvania', 'PA'],['Rhode Island', 'RI'],['South Carolina', 'SC'],['South Dakota', 'SD'],['Tennessee', 'TN'],['Texas', 'TX'],['Utah', 'UT'],['Vermont', 'VT'],['Virginia', 'VA'],['Washington', 'WA'],['West Virginia', 'WV'],['Wisconsin ', 'WI'],['Wyoming', 'WY']].freeze
    
	#Scope
	scope :chronological, -> { order(date_posted: :desc) }
	scope :incomplete,    -> { where(date_completed: nil)}
	scope :completed,     -> { where.not(date_completed: nil)}
	scope :posted_by,   -> (poster) { where(poster_id: poster.id) }
	scope :claimed_by, -> (claimer){joins(:post_claims).where("post_claims.claimer_id= ?",claimer.id)}
	scope :for_organization, ->(organization_id) {joins(:poster).where('organization_id = ?',organization_id )}
	scope :not_cancelled, ->{where(date_cancelled: nil)}
	scope :unclaimed, -> { joins("left join post_claims on posts.id=post_claims.post_id").where("post_claims.claimer_id is null") }
    scope :checkin, -> {joins("left join post_needs on posts.id = post_needs.post_id").where("post_needs.need_id is null")}
    scope :not_checkin, ->{joins("left join post_needs on posts.id = post_needs.post_id").where.not("post_needs.need_id is null")}
    scope :before_date, ->(date){where("date_posted > ? ", date)}


	# Validations
	validates_presence_of :street_1, :number_people, :poster_id,:camp_status
	validates_numericality_of :poster_id, only_integer: true
	validates_numericality_of :number_people, only_integer: true, greater_than_or_equal_to: 0, message: "should be an integer"
	validates_format_of :zip, with: /\A\d{5}\z/, message: "should be five digits long"
	validates_inclusion_of :state, in: STATES_LIST.map{|key, value| value}, message: "is not an option"
	validates_inclusion_of :state, in: STATES_LIST.to_h.values, message: "is not an option"
    validates_datetime :date_posted, on_or_before: lambda { DateTime.current }, allow_blank: true
    validates_datetime :date_completed, on_or_after: :date_posted, allow_blank: true
    validate :address_is_valid, on:  :create
    # validate :requests_selected

	#Callbacks
	before_create :set_datetime_posted_if_not_given
	#Gecoding
	geocoded_by :full_street_address
	after_validation :geocode


	before_destroy do 
	    check_if_anyneed_is_completed
	    if errors.present?
	      throw(:abort)
	    else
	      self.post_claims.each{|ci| ci.destroy}
	      self.post_needs.each{|pn| pn.destroy}
	      self.sharings.each{|s| s.destroy}
	    end
	end




	# class methods
	def self.for_all_alliances(org)
		ids = Array.new()
		org.alliances.each do |o|
			ids =ids+ o.all_org_ids
		end
		Post.joins(:poster).where('organization_id in (?)',ids)
	end

	def self.for_sharings(org)
		ids = Array.new()
		ids = ids+Post.for_organization(org.id).map(&:id)
		all_alliance_ids = org.all_alliance_ids
		Post.all.each do |p|
			alliance_list = p.alliances.map(&:id)
			if(alliance_list & all_alliance_ids)!=[] and !ids.include?(p.id)
				ids.push(p.id)
			end
		end
		Post.where('posts.id in (?)',ids)
	end

	#Methods
	def complete
		self.date_completed = DateTime.current
		self.save!
	end

	def check_in?
		return self.needs.size==0
	end

	def status
		return STATUS.to_h.key(self.camp_status)
	end


	def completed?
		return !self.date_completed.nil?
	end

	def cancelled?
		return !self.date_cancelled.nil?
	end


	def needs_all_claimed
		self.post_needs.each do |pn|
			if !pn.claimed?
				return false
			end
		end
		return true
	end

	def unclaim_by(i)
		self.post_claims.where("claimer_id= ?", i).destroy_all
		self.post_needs.where("claim_id= ?",i).each do |pn|
			pn.claim_id = nil
			pn.save!
		end
	end

	def can_unclaim?(user_id)
		self.post_needs.completed.each do |pn|
			if pn.claim_id == user_id
				return false
			end
		end
		return true
	end

	def can_delete?
		self.post_needs.each do |pn|
			if pn.complete?
				return false
			end
		end
		return true
	end

	def update_post_needs(new_completed_ids,user_id)
		completed_ids = new_completed_ids.select{ |id| id != '' }.map { |id| id.to_i }
		self.post_needs.each do |pn|
			if pn.claim_id == user_id
				if completed_ids.include? pn.id
					pn.complete
				else
					pn.undo_complete
				end
			end
		end
	end

	def update_need_claims(new_claimed_ids,user_id)
		claimed_ids = new_claimed_ids.select{ |id| id != '' }.map { |id| id.to_i }
		self.post_needs.each do |pn|
			if claimed_ids.include? pn.id and (pn.claim_id.nil? or pn.claim_id == user_id)
				pn.claim_id = user_id
				pn.save!
			elsif (!claimed_ids.include? pn.id) and pn.claim_id == user_id and pn.time_completed.nil?
				pn.claim_id = nil
				pn.save!
			end
		end
	end

	def is_claimer?(user)
		return self.claimers.map(&:id).include?(user.id)
	end

	def all_claimer_names
		return self.claimers.map(&:proper_name).join(", ")
	end

	def two_claimer_names
		return self.claimers.map(&:proper_name).take(2).join(", ")
	end

	def post_needs
		PostNeed.where(post_id: self.id)
	end

	def check_if_anyneed_is_completed
		self.post_needs.each do |pn|
			if pn.complete?
				errors.add(:base, "This post cannot be deleted due to some completed needs.")
			end
		end
	end

	def poster_name
		self.poster_id ? User.find(self.poster_id).proper_name : nil
	end

	def camp
		return nil if self.camp_id.nil?
		return Camp.find(self.camp_id).name
	end

	def self.filter_states(p, c,co,pt,num,date)
		result = ""
		if p.to_i !=0
			result+="Posted By: Myself	"
		elsif !p.nil? and p[0..2] == "org"
			result+="Posted By: My Organization	"
		end

		if c.to_i !=0
			result+="Claime Status: Myself	"
		elsif c == "unclaimed"
			result+="Claime Status: Unclaimed	"
		end

		if co == "incomplete"
			result+="Complete Status: Incomplete	"
		elsif co == "completed"
			result+="Complete Status: Completed	"
		elsif co == "not cancelled"
			result+="Complete Status: Not Cancelled	"
		end


		if pt == "check in"
			result+="Post Type: Check-in;	"
		elsif pt == "requests"
			result+="Post Type: Requests;	"
		end


		result+="Time Period: "+num.to_s+" "+date
		return result


	end


	def self.filter(posted_by, claim_status,complete_status,post_type,num,date)
		Post.filter_posted(posted_by).filter_claim(claim_status).filter_complete(complete_status).filter_check(post_type).filter_date(num,date)
	end
	def self.filter_date(num,date)
		num = num.to_i
		if date == "day"
			Post.before_date(num.day.ago)
		elsif date == "month"
			Post.before_date(num.month.ago)
		else
			Post.before_date(num.year.ago)
		end
	end

	def self.filter_posted(p)
		if p.to_i !=0
			Post.where(poster_id: p)
		elsif !p.nil? and p[0..2] == "org"
			Post.for_organization(p[3..-1].to_i)
		else
			Post.all
		end
	end

	def self.filter_claim(c)
		if c.to_i !=0
			Post.joins(:post_claims).where("post_claims.claimer_id= ?",c)
		elsif c == "unclaimed"
			Post.unclaimed
		else
			Post.all
		end
	end

	def self.filter_complete(c)
		if c == "incomplete"
			Post.incomplete
		elsif c == "completed"
			Post.completed
		elsif c == "not cancelled"
			Post.not_cancelled
		else
			Post.all
		end
	end

	def self.filter_check(c)
		if c == "check in"
			Post.checkin
		elsif c == "requests"
			Post.not_checkin
		else
			Post.all
		end
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
			"date_cancelled" => p.date_cancelled,
			"date_completed" => p.date_completed,
			"claimer" => !p.claimers.size.zero?,
			"checkin" => p.check_in?,
			"camp" => p.camp
		}}
	end


	def self.get_camps(posts,organization_id,admin)

		camps = []
		# puts("first put posts")
		# puts(posts)
		for post in posts
			if !post.camp_id.nil? and !camps.include?(post.camp_id)
			   camps.push(post.camp_id)
		    end
		end
		return camps.map{|c| Camp.find(c)}.select{|camp| camp.can_see(organization_id,admin) and !camp.lat.nil?}
	end

	#Methods for analytics
	#all posts in the same location

	# def claimed_by(user_id)
	# 	if self.claimer_id.nil?
	# 		self.claimer_id = user_id
	# 		self.date_cancelled = nil
	# 		self.date_claimed = Date.current
	# 		self.save!
	# 	else
	# 		false
	# 	end
 #    end

    def all_completed?
		self.post_needs.each do |n|
				if !n.complete? 
					return false
				end
	    end
	    return true

    end


	def cancel
		if self.date_cancelled.nil? and self.date_completed.nil?
			self.date_cancelled = Date.current
			self.post_claims.destroy_all
			self.post_needs.each do |pn|
				unless pn.complete?
					pn.claim_id = nil
					pn.save!
				end
			end
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

	# def requests_selected
	# 	return true if self.camp_status!="requests"
	# 	if self.post_needs.size == 0 
	# 		self.errors.add(:post,"has no request selected")
	# 	elsif self.number_people == 0 
	# 		self.error.add(:post,": number of people has to be greater than 0.")
	# 	end
	# end
end

