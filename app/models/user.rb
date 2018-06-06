class User < ActiveRecord::Base
	# get modules to help with some functionality
  include SociusWebHomelessHelpers::Validations

  # For use in authorizing with CanCan
  ROLES = [['Administrator', :admin],['Manager', :manager],['Social Worker', :worker]]
	# use has_secure_password
  has_secure_password
  
	#Relationships
	belongs_to :organization
  has_many :posts, foreign_key: :poster_id
  has_many :comments

	#Scopes
	scope :alphabetical,  -> { order(:last_name).order(:first_name) }
  scope :active,        -> { where(active: true) }
  scope :inactive,      -> { where(active: false) }
	scope :workers,       -> { where(role: 'worker') }
	scope :managers,      -> {where(role: 'manager')}
	scope :admin,         -> {where(role: 'admin')}
  scope :can_notify,    -> {where(email_notification: true)}

	#Validations
  validates :first_name, presence: true
  validates :last_name, presence: true
	validates :username, presence: true, uniqueness: { case_sensitive: false}
  validates :email, presence: true, uniqueness: { case_sensitive: false}, format: { with: /\A[\w]([^@\s,;]+)@(([\w-]+\.)+(com|edu|org|net|gov|mil|biz|info))\z/i, message: "is not a valid format" }
  validates :phone, format: { with: /\A\(?\d{3}\)?[-. ]?\d{3}[-.]?\d{4}\z/, message: "should be 10 digits (area code needed) and delimited with dashes only", allow_blank: true }
  validates :role, inclusion: { in: ROLES.map { |r| r[1].to_s }, message: "is not a recognized role in system" }
  validates_presence_of :password, on: :create 
  validates_presence_of :job_title
  validates_presence_of :organization_id
  validate :organization_is_active_in_system
  validates_presence_of :password_confirmation, on: :create 
  validates_confirmation_of :password, on: :create, message: "does not match"
  validates_length_of :password, minimum: 4, on: :create, message: "must be at least 4 characters long"

	# Other methods
  def name
    "#{last_name}, #{first_name}"
  end

  def proper_name
    "#{first_name} #{last_name}"
  end

  def organization
    if self.organization_id
      Organization.find(self.organization_id)
    end
  end

  def alliance
    if self.organization_id and self.organization.alliance_id
      Alliance.find(self.organization.alliance_id)
    end
  end

  def role?(authorized_role)
    return false if role.nil?
    role.downcase.to_sym == authorized_role
  end

  def approve
    self.update_attribute(:active, true)
  end


# Callbacks
  before_destroy :is_never_destroyable
  before_save :reformat_phone

  before_save :downcase_email_and_username
  
  private
  def reformat_phone
    phone = self.phone.to_s  # change to string in case input as all numbers 
    phone.gsub!(/[^0-9]/,"") # strip all non-digits
    self.phone = phone       # reset self.phone to new string
  end

  def downcase_email_and_username
    self.email = self.email.downcase
    self.username = self.username.downcase
  end

  def organization_is_active_in_system
    all_active = Organization.active.to_a.map{|o| o.id}
    unless all_active.include?(self.organization_id)
      errors.add(:organization, " is not active in the system")
    end
    true
  end

end
