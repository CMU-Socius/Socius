class UsersController < ApplicationController
skip_authorize_resource :only => [:change_password]
before_action :set_user, only: [:edit,:show,:approve,:update,:change_password]
load_and_authorize_resource

def index
	authorize! :manage, :all
	@active_users = User.active.alphabetical.paginate(:page => params[:page])
	@inactive_users = User.inactive.alphabetical.paginate(:page => params[:page])
end

def new
	@user = User.new
	@organizations = Organization.alphabetical
end

def edit

	@organizations = Organization.alphabetical
end

def show

	@claimed_posts = Post.not_cancelled.claimed_by(@user).paginate(:page => params[:page])
	@posts = Post.not_cancelled.posted_by(@user).paginate(:page => params[:page])
	@organization = @user.organization
	@alliances = @user.organization.alliances
end

def user_all_posts
end

def approve

	@user.active = true
	@user.save!
	UserNotifier.approved_notification(@user).deliver
	redirect_to users_path, notice: "Successfully approved this user!"
end

def create
	@user = User.new(user_params)

	if @user.save
		if logged_in? and current_user.role?(:admin)
			# user created by admin, redirect_to user profile
			redirect_to user_path(@user), notice: "Successfully created account: #{@user.username}."
		else
			# user created by guest, needs authorization from the admin
			UserNotifier.new_account_notification(@user).deliver
			redirect_to newaccount_path, notice: "Successfully created account: #{@user.username}."
		end
	else 
		@organizations = Organization.alphabetical
		render action: 'new'
	end
end

def update
	if @user.update(user_update_params)
    redirect_to user_path(@user), notice: "Successfully updated #{@user.username}"
    else
  	@organizations = Organization.alphabetical
    render action: "edit"
  end
    
end

def change_password
	authorize! :update,@user
	if @user.authenticate(params[:old])
		current_user.password = params[:password]
	    current_user.password_confirmation = params[:password_confirmation]
	    if current_user.save
	      redirect_to user_path(current_user),:notice => "Successfully updated your password."
	    else
	      @message = "Error: "
	      current_user.errors.full_messages.each do |m|
	        @message+=m
	        @message+=". "
	      end 
	      render action: "change_password"
	    end

	else
		@message = "Error: Invalid Old Password"
		render action: "change_password"
	end
end

private
	def set_user
		@user = User.find(params[:id])
	end

	def user_params
		params.require(:user).permit(:first_name, :last_name, :email, :phone, :username, :password, :password_confirmation, :role, :active, :job_title, :organization_id,:email_notification)
	end

	def user_update_params
		if logged_in? and current_user.role?(:admin)
		  params.require(:user).permit(:first_name, :last_name, :email, :phone, :username, :password, :password_confirmation, :role, :active, :job_title, :organization_id,:email_notification)
	    else
	      params.require(:user).permit(:first_name,:last_name,:phone,:job_title,:email_notification)
	    end

	end
end