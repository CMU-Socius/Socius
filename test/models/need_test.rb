require './test/test_helper'
class NeedTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  #Test relationships
  should have_many(:post_needs)

  #Test Validations
  should validate_presence_of(:name)
  should validate_uniqueness_of(:name).case_insensitive

  context "Within context" do
    setup do
      create_needs
    end

    teardown do
      destroy_needs
    end

    should "show that name is automatically capitalized" do
      @newNeed = FactoryGirl.create(:need, name: 'new')
      @newNeed.reload
      assert_equal "New", @newNeed.name

      @newNeed.delete
    end
  end

end
