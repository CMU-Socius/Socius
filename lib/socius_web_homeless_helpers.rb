# require needed files
require 'helpers/validations'
require 'helpers/gmap'

# create BreadExpressHelpers
module SociusWebHomelessHelpers
  include SociusWebHomelessHelpers::Validations
  include SociusWebHomelessHelpers::Gmap
end