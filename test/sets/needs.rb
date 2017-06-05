module Contexts
  module Needs
    # Context for needs
    def create_needs
      @food  = FactoryGirl.create(:need)
      @toiletries = FactoryGirl.create(:need, name: 'Toileteries')
      @clothes = FactoryGirl.create(:need, name: 'Clothes')
      @medical = FactoryGirl.create(:need, name: 'Medical')
    end
    
    def destroy_needs
      @food.delete
      @toiletries.delete
      @clothes.delete
      @medical.delete
    end

  end
end