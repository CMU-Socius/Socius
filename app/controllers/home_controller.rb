class HomeController < ApplicationController
#Social worker homepage allows them to make requests and view open requests
  def home
    @home = true

	end

  def about
    puts 'ABOUT'

    response = @@firebase.get("Staff")
    puts response.body
  end

  def contact
  end

  def privacy
  end
  
end