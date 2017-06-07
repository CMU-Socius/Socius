require './test/test_helper'

class PostTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  #Test relationships
  should have_many(:post_needs)
  should have_many(:needs).through(:post_needs)
  should belong_to(:poster)

  #Test simple validations with matchers
  should allow_value(DateTime.current).for(:date_posted)
  should allow_value(1.day.ago.to_datetime).for(:date_posted)
  should allow_value(nil).for(:date_completed)
  should_not allow_value(1.day.from_now.to_date).for(:date_posted)
  should_not allow_value("bad").for(:date_posted)
  should_not allow_value(2).for(:date_posted)
  should_not allow_value(3.14159).for(:date_posted)
  
  
  context "Within context" do
    setup do
      create_organizations
      create_worker_users
      create_worker_posts
    end

    teardown do
      destroy_worker_posts
      destroy_worker_users
      destroy_organizations
    end

    should "have claimed_by method" do
      #Test if not claimed
      @newOrg = FactoryGirl.create(:organization, name: 'new')
      @newWorker = FactoryGirl.create(:user, username: 'new', organization: @newOrg)
      assert_nil @worker2_p1.claimer_id
      @worker2_p1.claimed_by(@newWorker)
      assert_equal @worker2_p1.claimer_id, @newWorker.id
      #Test if claimed
      deny @worker2_p1.claimed_by(@worker_2)
      @newWorker.delete
      @newOrg.delete
    end

    should "have unclaim method" do
      #Test if not claimed
      #Test if claimed
      assert_not_nil @worker3_p1.claimer_id
      @worker3_p1.unclaim
      assert_nil @worker3_p1.claimer_id
    end
  

  end
end
