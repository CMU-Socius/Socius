module Contexts
  module Users
    # Context for both management and worker users (assumes organizations context)
    def create_management_users
      @ann   = FactoryGirl.create(:user, first_name: "Ann", last_name: "Doe", username: 'adoe', role: "manager", organization: @ssw)
      @ben   = FactoryGirl.create(:user, first_name: "Ben", last_name: "Person", username: "bperson", role: "admin", organization: @ssw)
      @man2 = FactoryGirl.create(:user, first_name: "Manager", last_name: "Two", username: "m2", role: "manager", organization: @shelter)
      @ad2 = FactoryGirl.create(:user, first_name: "Admin", last_name: "Two", username: "ad2", role: "admin", organization: @shelter)
      @inactive_admin = FactoryGirl.create(:user, first_name: "Admin", last_name: "Inactive", username: "inad", role: "admin", organization: @shelter, active: false)
    end
    
    def destroy_management_users
      @ann.delete
      @ben.delete
      @man2.delete
      @ad2.delete
      @inactive_admin.delete
    end

    def create_worker_users
      @worker1     = FactoryGirl.create(:user, first_name: "Alex", last_name: "Reynolds", username: "areynolds", organization: @ssw)
      @worker2     = FactoryGirl.create(:user, first_name: "Worker", last_name: "Two", username: "w2", phone: "615-213-1425", organization: @ssw)
      @worker3     = FactoryGirl.create(:user, first_name: "Worker", last_name: "Three", username: "w3", organization: @shelter)
      @inactive_worker = FactoryGirl.create(:user, first_name: 'Inactive', last_name: "Worker", username: "iw1", active: false, organization: @shelter)
    end

    def destroy_worker_users
      @worker1.delete
      @worker2.delete
      @worker3.delete
      @inactive_worker.delete
    end

  end
end