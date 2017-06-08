class PostNeed < ActiveRecord::Base
	#Relationships
	belongs_to :need
	belongs_to :post

	#Validations
	validates_datetime :time_completed, :on_or_before => lambda { DateTime.current }, allow_blank: true
	
	#Scopes
	scope :completed, -> {where.not(time_completed: nil)}
	scope :incomplete, -> {where(time_completed: nil)}


	#Methods
	def completed
		unless !self.time_completed.nil?
			set_time_completed_to_now
		end
	end


	private
	
	def set_time_completed_to_now
		self.time_completed = DateTime.current
		self.save!
	end

end
