module Contexts
  module Posts
    # Context for posts (assumes posters, organizations contexts)
    def create_worker_posts
      @worker2_p1 = FactoryGirl.create(:post, poster: @worker2, number_people: 2, latitude: 40.440078, longitude: -80.000761, street_1: "304 Forbes Ave")
      @worker2_p2 = FactoryGirl.create(:post, poster: @worker2,  date_posted: 4.weeks.ago.to_datetime)
      @worker3_p1 = FactoryGirl.create(:post, poster: @worker3, number_people: 3, latitude: 40.440078, longitude: -80.000761, street_1: "304 Forbes Ave", date_posted: 2.days.ago.to_datetime, claimer_id: User.all.sort.first.id)
    end

    def create_management_posts
       @ann_p1 = FactoryGirl.create(:post, poster: @ann, date_posted: three.months.ago.to_datetime)
       @ann_p2 = FactoryGirl.create(:post, poster: @ann, number_people: 4, date_posted: 3.weeks.ago.to_datetime)
    end

    def destroy_management_posts
      @ann_p1.delete 
      @ann_p2.delete
    end
    
    def destroy_worker_posts
      @worker2_p1.delete
      @worker2_p2.delete
      @worker3_p1.delete
    end

  end
end