class PostsController < ApplicationController
	before_action :set_post, only: [:show, :edit, :update, :destroy]
	before_action :check_login
	authorize_resource


def index
	@users = User.all.alphabetical
	@posts = Post.all.chronological
	# @hash = Gmaps4rails.build_markers(@posts) do |post, marker|
	# 	marker.lat post.latitude
	# 	marker.lng post.longitude
	# 	marker.json({:id => post.id})
	# 	marker.infowindow render_to_string(:partial => 'partials/post_box', :locals => {:object => post})
	# end

end

def show
end

def new
	@post = Post.new

	@all_needs = Need.all

	@post_need = @post.post_needs.build
end

def edit
end

def create
	@post = Post.new(post_params)

	params[:needs][:id].each do |need|
		if !need.empty?
			@post.post_needs.build(:need_id => need)
	
		end
	end

	if @post.save!
		redirect_to home_path, notice: "Added post!"
	else
		render_action 'new'
	end
end

def update
end

def destroy
end


private
	def set_post
		@post = Post.find(params[:id])
	end

	def post_params
		params.require(:post).permit(:street_1, :street_2, :latitude, :longitude, :zip, :city, :state, :number_people, :poster_id, :claimer_id, :date_posted, :date_completed, :meed_id, :need_name)
	end

end
