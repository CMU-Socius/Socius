module Contexts
  module Organizations
    # Context for organizations
    def create_organizations
      @ssw = FactoryGirl.create(:organization)
      @shelter = FactoryGirl.create(:organization, name: "Pittsburgh Homeless Shelter")
    end
    
    def destroy_organizations
      @ssw.delete
      @shelter.delete
    end

  end
end