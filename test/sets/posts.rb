module Contexts
  module Posts
    # Context for posts (assumes users, organizations contexts)
    def create_posts
      @alex_p1 = FactoryGirl.create(:post, user: @alex, date_posted: three.months.ago.to_datetime)
      @alex_p2 = FactoryGirl.create(:post, user: @alex, number_people: 4, date_posted: 3.weeks.ago.to_datetime)
      @worker2_p1 = FactoryGirl.create(:order, user: @worker2, number_people: 2, latitude: 40.440078, longitude: -80.000761, street_1: "304 Forbes Ave",date_posted: DateTime.current)
      @worker2_p2 = FactoryGirl.create(:order, user: @worker2,  date_posted: 4.weeks.ago.to_datetime)
      @worker3_p1 = FactoryGirl.create(:order, user: @worker3, latitude: 40.440078, longitude: -80.000761, street_1: "304 Forbes Ave", date_posted: 2.days.ago.to_datetime)
    end
    
    def destroy_posts
      @alex_p1.delete 
      @alex_p2.delete
      @worker2_p1.delete
      @worker2_p2.delete
      @worke3_p1.delete
    end

  end
end