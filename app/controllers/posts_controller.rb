class PostsController < ApplicationController
	before_action :set_post, only: [:show, :edit, :update, :destroy]
	before_action :check_login
	authorize_resource


def index
	posts = Post.all.chronological
	post_needs = posts.map { |p| p.post_needs.to_a.map {|pn| pn.need } }
	posters = posts.map { |p| User.find(p.poster_id) }
	@post_details = posts.zip(post_needs, posters)
end

def show
end

def new
	@post = Post.new
	@all_needs = Need.all
	@post_need = @post.post_needs.build
end

def edit
	set_post
	@all_needs = Need.all
	@post_need = @post.post_needs
end

def create
	@post = Post.new(post_params)

	if @post.save!
		params[:needs][:id].each do |need|
			if !need.empty?
				pn = PostNeed.new(:need_id => need, :post_id => @post.id)
				pn.save!
			end
		end
		redirect_to posts_path, notice: "Added post!"
	else
		render_action 'new'
	end
end

def update
	set_post
	if @post.update(post_params)
    redirect_to posts_path, notice: "Successfully updated post."
  else
  	@all_needs = Need.all
		@post_need = @post.post_needs.build
    render action: "edit"
  end
end

def destroy
end


private
	def set_post
		@post = Post.find(params[:id])
	end

	def post_params

		params.require(:post).permit(:street_1, :street_2, :latitude, :longitude, :zip, :city, :state, :number_people, :poster_id, :claimer_id, :date_posted, :date_completed, :needs, :comment)
	end

end
