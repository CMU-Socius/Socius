class Post < ActiveRecord::Base

	# get module to help with some functionality
  #include SociusWebHomelessHelpers::Validations
	
	#Relationships
	belongs_to :poster, class_name: :User, foreign_key: :poster_id
  has_many :post_needs
  has_many :needs, through: :post_needs

	# get an array of the states in U.S.
  STATES_LIST = [['Alabama', 'AL'],['Alaska', 'AK'],['Arizona', 'AZ'],['Arkansas', 'AR'],['California', 'CA'],['Colorado', 'CO'],['Connectict', 'CT'],['Delaware', 'DE'],['District of Columbia ', 'DC'],['Florida', 'FL'],['Georgia', 'GA'],['Hawaii', 'HI'],['Idaho', 'ID'],['Illinois', 'IL'],['Indiana', 'IN'],['Iowa', 'IA'],['Kansas', 'KS'],['Kentucky', 'KY'],['Louisiana', 'LA'],['Maine', 'ME'],['Maryland', 'MD'],['Massachusetts', 'MA'],['Michigan', 'MI'],['Minnesota', 'MN'],['Mississippi', 'MS'],['Missouri', 'MO'],['Montana', 'MT'],['Nebraska', 'NE'],['Nevada', 'NV'],['New Hampshire', 'NH'],['New Jersey', 'NJ'],['New Mexico', 'NM'],['New York', 'NY'],['North Carolina','NC'],['North Dakota', 'ND'],['Ohio', 'OH'],['Oklahoma', 'OK'],['Oregon', 'OR'],['Pennsylvania', 'PA'],['Rhode Island', 'RI'],['South Carolina', 'SC'],['South Dakota', 'SD'],['Tennessee', 'TN'],['Texas', 'TX'],['Utah', 'UT'],['Vermont', 'VT'],['Virginia', 'VA'],['Washington', 'WA'],['West Virginia', 'WV'],['Wisconsin ', 'WI'],['Wyoming', 'WY']].freeze

	#Scope
	scope :chronological, -> { order(date: :desc) }
	scope :active,        -> { where(active: true) }
	scope :inactive,      -> { where(active: false) }


	# Validations
	validates_presence_of :street_1, :number_people, :poster_id
	validates_numericality_of :poster_id, only_integer: true
	validates_numericality_of :claimer_id, only_integer: true, allow_blank: true
	validates_numericality_of :number_people, only_integer: true, greater_than: 0
	validates_format_of :zip, with: /\A\d{5}\z/, message: "should be five digits long"
	validates_inclusion_of :state, in: STATES_LIST.map{|key, value| value}, message: "is not an option"
	validates_inclusion_of :state, in: STATES_LIST.to_h.values, message: "is not an option"
  validates_datetime :date_posted, on_or_before: lambda { DateTime.current }, allow_blank: true
  validates_date :date_completed, on_or_after: :date_posted, allow_blank: true
	#validate :user_is_active_in_system


	private
	def user_is_active_in_system
    is_active_in_system(:user)
  end

	 def set_datetime_posted_if_not_given
    unless self.date_posted && self.date_posted.is_a?(DateTime)
      self.date_posted = DateTime.current
    end
  end





end

