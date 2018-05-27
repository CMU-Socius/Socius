class HomeController < ApplicationController
#Social worker homepage allows them to make requests and view open requests
  def home
	end

  def about
    @team = [
      { name: "Min Kyung Lee", link: "http://www.cs.cmu.edu/~mklee/" },
      { name: "Yasser Shoukry", link: "" },
      { name: "Vasu Raman", link: "" },
      { name: "Mani Srivastava", link: "http://www.ee.ucla.edu/mani-srivastava/" },
      { name: "Lisa Otto", link: "http://www.lisaot.to/" },
      { name: "Vincent Kang", link: "http://www.vincentkang.me/" },
      { name: "Sean Park", link: "https://spark33.github.io/" },
      { name: "Grace Wong", link: "https://gwcreatives.carbonmade.com/about" },
    ]
  end

  def privacy
  end

  def newaccount
  end
  
end