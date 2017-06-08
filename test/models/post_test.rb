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
      destroy_organizations
      destroy_worker_users
      destroy_worker_posts
    end

    #Scope tests

    should "have a working scope called chronological" do
      assert_equal [2,3,1], Post.chronological.all.map(&:number_people)
    end

    should "have a working scope called incomplete" do
      @worker2_p1.complete
      assert_equal [1,3], Post.incomplete.all.map(&:number_people).sort
    end

    should "have a working scope called completed " do
      @worker2_p1.complete
      @worker2_p2.complete
      assert_equal [1,2], Post.completed.all.map(&:number_people).sort
    end

    should "have a working scope called for_claimer" do
      @worker2_p1.claimed_by(User.all.sort.first)
      assert_equal [2,3], Post.for_claimer(User.all.sort.first).all.map(&:number_people).sort
    end

    should "verify that the date is set for today unless otherwise specified" do
      #test is working but timezone specification is not saved to database along with the rest of the timestamp
      assert_equal @worker3_p1.date_posted, 2.days.ago.to_datetime# a specified date is unchanged
      @worker3_p2 = FactoryGirl.create(:post, poster: @worker3, number_people: 3, date_posted: nil)
      assert_equal @worker3_p2.date_posted, DateTime.current  # an order without any date is set to today by default
   
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
