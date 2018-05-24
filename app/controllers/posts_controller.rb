class PostsController < ApplicationController
	before_action :set_post, only: [:show, :edit, :update, :destroy]
	before_action :check_login
	authorize_resource


def index
	if current_user.role? :admin
		posts = Post.all.chronological
	elsif current_user.role? :worker
		posts = Post.for_organization(current_user.organization_id).chronological
		posts = Post.all.chronological
	end

	# posts = Post.all.chronological
	@post_details = Post.get_post_details(posts)
end

def show
	@poster = @post.poster
	@post_details = Post.get_post_details([@post])
	@post_needs = @post.post_needs.alphabetical
end

def new
	@post = Post.new
	@all_needs = Need.by_category
	@post_need = @post.post_needs.build
end

def edit
	set_post
	@all_needs = Need.by_category
	@post_need = @post.post_needs
end

def create
	@post = Post.new(post_params)

	# check that there is a need selected
	all_empty = true
	params[:needs][:id].each do |need_id|
		if !need_id.empty?
			all_empty = false
		end
	end
	if all_empty
		@post.errors.add(:no_needs, "were selected.")
		@all_needs = Need.by_category
		@post_need = @post.post_needs.build
		render action: 'new' and return
	end

	# then try to save the post
	if @post.save
		params[:needs][:id].each do |need_id|
			unless need_id.empty?
				pn = PostNeed.new(:need_id => need_id, :post_id => @post.id)
				pn.save!
			end
		end
		# UserNotifier.send_post_notification(@post).deliver_later
		redirect_to posts_path, notice: "Added post!"
	else
		@all_needs = Need.by_category
		@post_need = @post.post_needs.build
		render action: 'new'
	end
end

def update
	set_post
	if @post.update(post_params)
	    redirect_to posts_path, notice: "Successfully updated post."
	else
	  	@all_needs = Need.by_category
			@post_need = @post.post_needs.build
	    render action: "edit"
	end
end

def update_needs
	post_id = params['post']['id'].to_i
	@post = Post.find(post_id)
	@post.update_post_needs(params['post_needs']['completed_ids'])
	@post.date_completed = DateTime.current
	@post.post_needs.each do |n|
		if !n.complete? 
			@post.date_completed = nil

		end
	end

	@post.save!
	redirect_to post_path(post_id), notice: "Updated post!"
end

def destroy
end

def claim
	set_post
	@post.claimed_by(session[:user_id].to_i)
	posts = Post.all.chronological
	@post_details = Post.get_post_details(posts)
	redirect_to posts_path, notice: "Claimed request!"
end

def unclaim
	set_post
	@post.unclaim
	posts = Post.all.chronological
	@post_details = Post.get_post_details(posts)
	redirect_to posts_path, notice: "Unclaimed request!"
end

def cancel
	set_post
	@post.cancel
	posts = Post.all.chronological
	@post_details = Post.get_post_details(posts)
	redirect_to posts_path, notice: "Cancelled request!"
end


private
	def set_post
		@post = Post.find(params[:id])
	end

	def post_params

		params.require(:post).permit(:street_1, :street_2, :latitude, :longitude, :zip, :city, :state, :number_people, :poster_id, :claimer_id, :date_posted, :date_completed, :needs, :comment)
	end

end
