class PostsController < ApplicationController
	before_action :set_post, only: [:show, :edit, :update, :destroy]
	before_action :check_login
	authorize_resource


def index 
	if current_user.role? :admin
		@posts = Post.filter(params[:posted_by],params[:claim_status],params[:complete_status]).chronological.paginate(:page => params[:page])
	elsif current_user.role? :worker
		@posts = Post.filter(params[:posted_by],params[:claim_status],params[:complete_status]).for_sharings(current_user.organization).chronological.paginate(:page => params[:page])
	end
	@posts.current_page
	@post_details = Post.get_post_details(@posts)
	@default_p = params[:posted_by].nil? ? "anyone" : params[:posted_by]
	@default_c = params[:claim_status].nil? ? "all" : params[:claim_status]
	@default_o = params[:complete_status].nil? ? "all" : params[:complete_status]

	
end

def show
	@poster = @post.poster
	@post_details = Post.get_post_details([@post])
	@post_needs = @post.post_needs.alphabetical
	@sharings = @post.alliances.map(&:name)
end

def new
	@post = Post.new
	@all_needs = Need.by_category
	@alliances = current_user.organization.alliances
	@post_need = @post.post_needs.build
	@sharings = @post.sharings.build
end

def edit
	set_post
	@all_needs = Need.by_category
	@alliances = current_user.organization.alliances
	@post_need = @post.post_needs
	@sharings = @post.sharings.build
end

def create
	@post = Post.new(post_params)
	@alliances = current_user.organization.alliances

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
		unless @alliances.size == 0
			params[:alliances][:ids].each do |sharing_id|
				unless sharing_id.empty?
					s = Sharing.new(:post_id => @post.id,:alliance_id => sharing_id)
					s.save!
				end
			end
	    end
	    #email the users
		UserNotifier.send_post_notification(@post).deliver_later
		redirect_to posts_path, notice: "Added post!"
	else
		@all_needs = Need.by_category
		@alliances = current_user.organization.alliances
		@post_need = @post.post_needs.build
		@sharings = @post.sharings.build
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
	@post.update_post_needs(params['post_needs']['completed_ids'],current_user.id)
	if @post.all_completed? 
		@post.date_completed = DateTime.current
	else
		@post.date_completed = nil
	end
	@post.save!
	redirect_to post_path(post_id), notice: "Updated post!"
end

def update_claims
	post_id = params['post']['id'].to_i
	@post = Post.find(post_id)
	@post.update_need_claims(params['post_needs']['claim_ids'],current_user.id)
	@post.save!
	redirect_to post_path(post_id), notice: "Updated post!"
end

def destroy
	@post.destroy
	redirect_to posts_path, notice: "This post is deleted."
end

def claim
	set_post
	@post_claim = PostClaim.new
	@post_claim.post_id = @post.id
	@post_claim.claimer_id = session[:user_id].to_i
	@post_claim.save
	redirect_to post_path(@post), notice: "Claimed request!"
end

def unclaim
	set_post
	if @post.can_unclaim?(current_user.id)
		@post.unclaim_by(current_user.id)
	end
	# if current_user.role? :admin
	# 	posts = Post.where(date_cancelled: nil).chronological.paginate(:page => params[:page])
	# elsif current_user.role? :worker
	# 	posts = Post.where(date_cancelled: nil).for_organization(current_user.organization_id).chronological.paginate(:page => params[:page])
	# end
	redirect_to posts_path, notice: "Unclaimed request!"
end

def cancel
	set_post
	@post.cancel
	if current_user.role? :admin
		posts = Post.where(date_cancelled: nil).chronological.paginate(:page => params[:page])
	elsif current_user.role? :worker
		posts = Post.where(date_cancelled: nil).for_organization(current_user.organization_id).chronological.paginate(:page => params[:page])
	end
	redirect_to posts_path, notice: "Cancelled request!"
end

def cancell
	set_post
	@post.cancel
	redirect_to post_path(@post), notice: "Cancelled request!"
end


private
	def set_post
		@post = Post.find(params[:id])
	end

	def post_params

		params.require(:post).permit(:street_1, :street_2, :latitude, :longitude, :zip, :city, :state, :number_people, :poster_id, :date_posted, :date_completed, :needs, :alliances,:comment)
	end

end
