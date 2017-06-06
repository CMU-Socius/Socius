module Contexts
  module Organizations
    # Context for organizations
    def create_organizations
      @ssw = FactoryGirl.create(:organization)
      @shelter = FactoryGirl.create(:organization, name: "Pittsburgh Homeless Shelter")
      @inactive_org = FactoryGirl.create(:organization, name: "Inactive Organization", active: false)
    end
    
    def destroy_organizations
      @ssw.delete
      @shelter.delete
      @inactive_org.delete
    end

  end
end