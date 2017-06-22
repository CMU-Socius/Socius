class PostsController < ApplicationController
	before_action :set_post, only: [:show, :edit, :update, :destroy]


def index
	@posts = Post.all.chronological
	@hash = Gmaps4rails.build_markers(@posts) do |post, marker|
		marker.lat post.latitude
		marker.lng post.longitude
		marker.json({:id => post.id})
		marker.infowindow render_to_string(:partial => 'partials/post_box', :locals => {:object => post})
	end

end

def show
end

def new
	@post = Post.new
end

def edit
end

def create
	@post = Post.new(post_params)
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




end
