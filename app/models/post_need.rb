class PostNeed < ActiveRecord::Base
	#Relationships
	belongs_to :need
	belongs_to :post
	belongs_to :claim, class_name: :User, foreign_key: :claim_id

	#Validations
	validates_datetime :time_completed, :on_or_before => lambda { DateTime.current }, allow_blank: true
	
	#Scopes
	scope :alphabetical, -> {joins(:need).order('name')}
	scope :completed, -> {where.not(time_completed: nil)}
	scope :incomplete, -> {where(time_completed: nil)}
	scope :claimed, -> {where.not(claim_id: nil)}
	scope :unclaimed, -> {where(claim_id: nil)}
	scope :claimed_by, ->(user){where("claim_id= ?",user.id)}


	#Methods
	def complete?
		not self.time_completed.nil?
	end

	def complete
		if self.time_completed.nil?
			set_time_completed_to_now
		end
	end

	def claimed?
		not self.claim_id.nil?
	end


	def self.completed_ids
		where.not(time_completed: nil).map { |pn| pn.id }
	end

	def self.claim_ids
		where.not(claim_id: nil).map { |pn| pn.id }
	end

	def undo_complete
		self.time_completed = nil
		self.save!
	end

	def need
		Need.find(self.need_id)
	end

	def need_name
		Need.find(self.need_id).name
	end


	private
	
	def set_time_completed_to_now
		self.time_completed = DateTime.current
		self.save!
	end

end
