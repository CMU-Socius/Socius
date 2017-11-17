class PostNeedsController < ApplicationController

	def complete
		post_need = PostNeed.find(params[:id])
		post_need.completed
		redirect_to posts_path, notice: "Request Need Completed!"
	end

	def undo_complete
		post_need = PostNeed.find(params[:id])
		post_need.undo_completed
		redirect_to posts_path, notice: "Request Need is now incomplete."
	end

end
