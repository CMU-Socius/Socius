class PostNeed < ActiveRecord::Base
	#Relationships
	belongs_to :needs
	belongs_to :posts

	#Validations
	validates_datetime :time_completed, :on_or_before => lambda { DateTime.current }, allow_blank: true
	
	#Scopes
	scope :completed, -> {where.not(time_completed: nil)}
	scope :incomplete, -> {where(time_completed: nil)}


	#Methods
	def completed
		set_time_completed_to_now
	end

	def set_time_completed_to_now
		self.time_completed = DateTime.current
		self.save!
	end

end
