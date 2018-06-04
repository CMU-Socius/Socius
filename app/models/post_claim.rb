class PostClaim < ActiveRecord::Base
    include SociusWebHomelessHelpers::Validations
    belongs_to :post
	belongs_to :claimer, class_name: :User, foreign_key: :claimer_id
end
