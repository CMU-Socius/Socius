class Comment < ActiveRecord::Base
	include SociusWebHomelessHelpers::Validations

	belongs_to :post
	belongs_to :user

	scope :chronological, -> { order(time_commented: :asc) }
	scope :for_post, ->(post_id){where(post_id: post_id)}

	before_create :set_time_commented

	validates :content, presence: true, allow_blank: false


	def set_time_commented
		if self.time_commented.nil?
		  self.time_commented = DateTime.current
		end
	end

	def poster
		return self.user.proper_name
	end

end
