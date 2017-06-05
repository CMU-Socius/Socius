module Contexts
  module PostNeeds
    # Context for post_needs (assumes post, need contexts plus contexts associated with post)
    def create_post_needs
      @alex_p1_1 = FactoryGirl.create(:post_need, post: @alex_p1, need: @food)
      @alex_p1_2 = FactoryGirl.create(:post_need, post: @alex_p1, need: @toiletries)
      @alex_p2_1 = FactoryGirl.create(:post_need, post: @alex_p2, need: @food)
      @alex_p2_2 = FactoryGirl.create(:post_need, post: @alex_p2, need: @toiletries)
      @alex_p2_3 = FactoryGirl.create(:post_need, post: @alex_p2, need: @clothes)
      @alex_p2_4 = FactoryGirl.create(:post_need, post: @alex.p2, need: @medical)
      @worker_2_p1_1 = FactoryGirl.create(:post_need, post: @worker_2_p1, need: @toiletries)
      @worker_2_p2_1 = FactoryGirl.create(:post_need, post: @worker_2_p2, need: @medical)
      @worker_2_p2_2 = FactoryGirl.create(:post_need, post: @worker_2_p1, need: @clothes)
      @worker_3_p1_1 = FactoryGirl.create(:post_need, post: @worker_3_p1, need: @food )
      
    end
    
    def destroy_post_needs
      @alex_p1_1.delete
      @alex_p1_2.delete
      @alex_p2_1.delete
      @alex_p2_2.delete
      @alex_p2_3.delete
      @alex_p2_4.delete
      @worker_2_p1_1.delete
      @worker_2_p2_1.delete
      @worker_2_p1_2.delete
      @worker_3_p1_1.delete

    end

  end
end


