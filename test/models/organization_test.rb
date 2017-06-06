require './test/test_helper'

class OrganizationTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  #Test relationships
  should have_many(:users)

  #Test validations
  should validate_presence_of (:name)

  #Set up context
  context "Within context" do
    setup do
      create_organizations
    end

    teardown do
      destroy_organizations
    end
  

  #Test scopes
  should "show that there are two organizations in alphabetical order" do
    assert_equal ["Inactive Organization", "Pittsburgh Homeless Shelter", "Pittsburgh Social Workers"], Organization.alphabetical.all.map(&:name)
  end

  should "show that there are two active organizations and one inactive organization" do
      assert_equal ["Pittsburgh Homeless Shelter", "Pittsburgh Social Workers"], Organization.active.all.map(&:name).sort
      assert_equal ["Inactive Organization"], Organization.inactive.all.map(&:name).sort
    end

   should "verify organization is not already in the system" do
      bad_org = FactoryGirl.build(:organization, name: "Pittsburgh Social Workers")
      # assert bad_school.already_exists?
      deny bad_org.valid?
    end 



  end

end
