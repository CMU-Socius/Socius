class Sharing < ActiveRecord::Base
	include SociusWebHomelessHelpers::Validations
	belongs_to :post
	belongs_to :alliance
end
