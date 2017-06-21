class PostsController < ApplicationController
	before_action :set_post, only: [:show, :edit, :update, :destroy]


def index
	@posts = Post.all.chronological.to_a
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
