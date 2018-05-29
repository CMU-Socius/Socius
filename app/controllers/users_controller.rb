class UsersController < ApplicationController
	
before_action :check_login, except: [:new, :create]
authorize_resource

def index
	@active_users = User.active.alphabetical.paginate(:page => params[:page])
	@inactive_users = User.inactive.alphabetical.paginate(:page => params[:page])
end

def new
	@user = User.new
	@organizations = Organization.alphabetical
end

def edit
	set_user
	@organizations = Organization.alphabetical
end

def show
	set_user
	@claimed_posts = Post.not_cancelled.claimed_by(@user).paginate(:page => params[:page])
	@posts = Post.not_cancelled.posted_by(@user).paginate(:page => params[:page])
	if @user.organization_id
		@organization = Organization.find(@user.organization_id)
		if @organization.alliance_id
			@alliance = Alliance.find(@organization.alliance_id)
		end
	end
end

def user_all_posts
end

def approve
	set_user
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
		puts("nere")
		@organizations = Organization.alphabetical
		render action: 'new'
	end
end

def update
	set_user
	if @user.update(user_params)
    redirect_to user_path(@user), notice: "Successfully updated #{@user.username}"
  else
  	@organizations = Organization.alphabetical
    render action: "edit"
  end
    
end

private
	def set_user
		@user = User.find(params[:id])
	end

	def user_params
		params.require(:user).permit(:first_name, :last_name, :email, :phone, :username, :password, :password_confirmation, :role, :active, :job_title, :organization_id)
	end
end