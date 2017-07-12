module SociusWebHomelessHelpers
  module Gmap

    #call this
    #static google map
    def google_map(center)
      "https://maps.googleapis.com/maps/api/staticmap?center=#{center}&size=300x300&zoom=17"
    end

  end
end