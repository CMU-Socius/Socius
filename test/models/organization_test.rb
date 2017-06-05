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
  end

  #Test scopes
  should "show that there are two organizations in alphabetical order" do
    puts Organization.all.to_a
    assert_equal ["Pittsburgh Homeless Shelter", "Pittsburgh Social Workers"], Organization.alphabetical.all.map(&:name)
  end

  should "show that there are two active organizations" do
      assert_equal ["Pittsburgh Homeless Shelter", "Pittsburgh Social Workers"], Organization.active.all.map(&:name).sort
    end

end
