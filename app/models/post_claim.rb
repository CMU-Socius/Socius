class PostClaim < ActiveRecord::Base
    include SociusWebHomelessHelpers::Validations

    belongs_to :post
	belongs_to :claimer, class_name: :User, foreign_key: :claimer_id

	validate :not_claimed, on: :create


	def not_claimed
		return true if self.post.nil? || self.claimer.nil?
		unless PostClaim.where(post_id: self.post_id, claimer_id: self.claimer_id).to_a.empty?
		  errors.add(:base, "This user has already claimed the request!")
		end
	end



end
