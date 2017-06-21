class UsersController < ApplicationController
	
	before_action :check_login, except: [:new, :create]
	# load_and_authorize_resource

def index
	@active_users = User.active.alphabetical.to_a
end

def new
	@user = User.new
end

def edit
	set_user
end

def show
	set_user
end

def user_all_posts
end

def create
	@user = User.new(user_params)
	if @user.save
		redirect_to home_path, notice: "Successfully added new user: #{@user.username}."
	else
		render action: 'new'
	end
end

private
	def set_user
		@user = User.find(params[:id])
	end

	def user_params
		params.require(:user).permit(:first_name, :last_name, :email, :phone, :username, :password, :password_confirmation, :role, :active)
	
	end
end