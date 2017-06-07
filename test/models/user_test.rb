require './test/test_helper'

class UserTest < ActiveSupport::TestCase
  should have_many(:posts)
  should have_secure_password

  # test validations
  should validate_presence_of(:username)
  should validate_presence_of(:email)
  should validate_uniqueness_of(:username).case_insensitive
  should validate_uniqueness_of(:email).case_insensitive
  should validate_inclusion_of(:role).in_array(%w[admin manager worker])
  
  # additional tests for role (not essential)
  should allow_value("admin").for(:role)
  should allow_value("manager").for(:role)
  should allow_value("worker").for(:role)
  should_not allow_value("bad").for(:role)
  should_not allow_value("hacker").for(:role)
  should_not allow_value(10).for(:role)
  should_not allow_value("leader").for(:role)
  should_not allow_value(nil).for(:role)
  
  # tests for phone
  should allow_value("4122683259").for(:phone)
  should allow_value("412-268-3259").for(:phone)
  should allow_value("412.268.3259").for(:phone)
  should allow_value("(412) 268-3259").for(:phone)
  should allow_value(nil).for(:phone)
  should_not allow_value("2683259").for(:phone)
  should_not allow_value("14122683259").for(:phone)
  should_not allow_value("4122683259x224").for(:phone)
  should_not allow_value("800-EAT-FOOD").for(:phone)
  should_not allow_value("412/268/3259").for(:phone)
  should_not allow_value("412-2683-259").for(:phone)
  
  
  # context
  context "Within context" do
    setup do
      create_organizations
      create_management_users
      create_worker_users
      create_worker_posts
    
    end
    
    teardown do
      destroy_worker_posts
      destroy_worker_users
      destroy_management_users
      destroy_organizations
    end
    
    should "have a name method for last, first name listing" do
      assert_equal "Doe, Ann", @ann.name
    end
    
    should "have a proper_name method for first & last name listing" do
      assert_equal "Ann Doe", @ann.proper_name
    end

    should "require users to have unique, case-insensitive usernames" do
      assert_equal "adoe", @ann.username
      # try to switch to Alex's username 'tank'
      @ann.username = "BPERSON"
      deny @ann.valid?, "#{@ann.username}"
    end

    should "require a password for new users" do
      bad_user = FactoryGirl.build(:user, username: "wheezy", password: nil, organization: @ssw)
      deny bad_user.valid?
    end
    
    should "require passwords to be confirmed and matching" do
      bad_user_1 = FactoryGirl.build(:user, username: "wheezy", password: "secret", password_confirmation: nil, organization: @ssw)
      deny bad_user_1.valid?
      bad_user_2 = FactoryGirl.build(:user, username: "wheezy", password: "secret", password_confirmation: "sauce", organization: @ssw)
      deny bad_user_2.valid?
    end
    
    should "require passwords to be at least four characters" do
      bad_user = FactoryGirl.build(:user, username: "wheezy", password: "no", password_confirmation: "no", organization: @ssw)
      deny bad_user.valid?
    end

    should "have a role? method to use in authorization" do
      assert @ann.role?(:manager)
      deny @ann.role?(:worker)
      assert @worker2.role?(:worker)
      deny @worker2.role?(:admin)
    end

    should "have a working scope called active" do
      assert_equal ["ad2","adoe","areynolds","bperson","m2","w2","w3"], User.active.all.map(&:username).sort
    end

    should "have a working scope called inactive" do
      assert_equal ["inad","iw1"], User.inactive.all.map(&:username).sort
    end

    should "have a working scope called workers" do
      assert_equal ["areynolds","iw1","w2","w3"], User.workers.all.map(&:username).sort
    end

     should "have a working scope called managers" do
      assert_equal ["adoe","m2"], User.managers.all.map(&:username).sort
    end

    should "have a working scope called admin" do
      assert_equal ["ad2","bperson","inad"], User.admin.all.map(&:username).sort
    end
    
    should "have a working scope called alphabetical" do
      assert_equal ["Doe, Ann", "Inactive, Admin", "Person, Ben", "Reynolds, Alex", "Three, Worker","Two, Admin", "Two, Manager", "Two, Worker", "Worker, Inactive"], User.alphabetical.all.map(&:name)
    end
    
    should "shows that Mark's phone is stripped of non-digits" do
      assert_equal "6152131425", @worker2.phone
    end

    should "shows that a user cannot be destroyed" do
      assert @ann.active
      deny @ann.destroy
      @ann.reload
      assert @ann.active
    end

  end
end
