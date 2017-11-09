class UsersController < ApplicationController
	
before_action :check_login, except: [:new, :create]
authorize_resource

def index
	@active_users = User.active.alphabetical.to_a
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
	claimed_posts = Post.claimed_by(@user)
	@claimed_post_details = Post.get_post_details(claimed_posts)

	posts = Post.posted_by(@user)
	@post_details = Post.get_post_details(posts)
	if @user.organization_id
		@organization = Organization.find(@user.organization_id)
		if @organization.alliance_id
			@alliance = Organization.where(alliance_id: @organization.alliance_id)
		end
	end
end

def user_all_posts
end

def create
	@user = User.new(user_params)
	if @user.save
		redirect_to home_path, notice: "Successfully added new user: #{@user.username}."
	else
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