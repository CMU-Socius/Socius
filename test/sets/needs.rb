module Contexts
  module Needs
    # Context for needs
    def create_purchases
      @p_vboards  = FactoryGirl.create(:purchase, item: @vinyl_green, quantity: 50, date: 2.months.ago.to_date)
      @p_vboards2 = FactoryGirl.create(:purchase, item: @vinyl_green, quantity: 25, date: 2.weeks.ago.to_date)
      @p_bpieces  = FactoryGirl.create(:purchase, item: @basic_pieces, quantity: 100, date: 1.month.ago.to_date)
      @p_loss     = FactoryGirl.create(:purchase, item: @basic_pieces, quantity: -10, date: 1.week.ago.to_date)
      @p_clocks   = FactoryGirl.create(:purchase, item: @analog_clock, quantity: 30)
    end
    
    def destroy_purchases
      @p_vboards.delete
      @p_vboards2.delete
      @p_bpieces.delete
      @p_loss.delete
      @p_clocks.delete
    end

  end
end