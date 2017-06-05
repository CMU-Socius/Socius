module Contexts
  module PostNeeds
    # Context for post_needs (assumes post, need contexts plus contexts associated with post)
    def create_post_needs
      @alex_p1_1 = FactoryGirl.create(:post_need, order: @alex_p1, need: @food)
      @alex_p2 = FactoryGirl.create(:order_item, order: @karen_o1, item: @basic_pieces, quantity: 5, shipped_on: 4.days.ago.to_date)
      @karen_o1_3 = FactoryGirl.create(:order_item, order: @karen_o1, item: @demo_board, quantity: 1, shipped_on: 4.days.ago.to_date)
      @karen_o2_1 = FactoryGirl.create(:order_item, order: @karen_o2, item: @chess_bag_green, quantity: 5, shipped_on: 2.days.ago.to_date)
      @karen_o3_1 = FactoryGirl.create(:order_item, order: @karen_o3, item: @vinyl_green, quantity: 5)
      @karen_o3_2 = FactoryGirl.create(:order_item, order: @karen_o3, item: @basic_pieces, quantity: 5)
      @markv_o1_1 = FactoryGirl.create(:order_item, order: @markv_o1, item: @demo_board, quantity: 1, shipped_on: 3.days.ago.to_date)
      @markv_o2_1 = FactoryGirl.create(:order_item, order: @markv_o2, item: @scorebook, quantity: 10)
      @ben_o1_1   = FactoryGirl.create(:order_item, order: @ben_o1, item: @vinyl_green, quantity: 10)
      @ben_o1_2   = FactoryGirl.create(:order_item, order: @ben_o1, item: @weighted_pieces, quantity: 10)
      @ben_o1_3   = FactoryGirl.create(:order_item, order: @ben_o1, item: @analog_clock, quantity: 10)
    end
    
    def destroy_post_needs
      @karen_o1_1.delete
      @karen_o1_2.delete
      @karen_o1_3.delete
      @karen_o2_1.delete
      @karen_o3_1.delete
      @karen_o3_2.delete
      @markv_o1_1.delete
      @markv_o2_1.delete
      @ben_o1_1.delete
      @ben_o1_2.delete
      @ben_o1_3.delete
    end

  end
end


