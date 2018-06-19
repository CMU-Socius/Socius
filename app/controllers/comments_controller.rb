class CommentsController < ApplicationController
	before_action :set_comment, only: [:destroy]

	def new
        @comment = Comment.new
    end


    def create
	    @comment = Comment.new(comment_params)
	    if @comment.save
	    	redirect_to post_path(@comment.post_id),notice:"Successfully added comment"
	    	UserNotifier.comment_notification(@comment.post,@comment).deliver_later
	    else
	    	redirect_to post_path(@comment.post_id),notice:"No blank comment!"
	    end
	    
	 end

	 def destroy
		@comment.destroy
		redirect_to post_path(@comment.post_id),notice:"Deleted comment"
	 end


	 private
	 def set_comment
		@comment = Comment.find(params[:id])
	 end
	 def comment_params
	 	params.require(:comment).permit(:user_id,:content,:post_id)
	 end

end
