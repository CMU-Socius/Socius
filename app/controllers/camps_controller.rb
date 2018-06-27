class CampsController < ApplicationController
	before_action :set_camp, only: [:draw_area,:update,:show]
	before_action :check_login
	authorize_resource

	def index
		if logged_in? and current_user.role?(:admin)
			@camps = Camp.active.has_area.paginate(:page => params[:page])
			@camp_details = Camp.get_camp_details(@camps)
	    else
	    	@camps = current_user.organization.camps.active.has_area.paginate(:page => params[:page])
	    	@camp_details = Camp.get_camp_details(@camps)
	    end
	end

	def new
		@camp = Camp.new
	end
	def create
		@camp = Camp.new(camp_params)
		if @camp.save
			@camp_org = CampOrg.new(camp_id: @camp.id,organization_id: current_user.organization_id)
			@camp_org.save
			redirect_to draw_area_path(id: @camp.id)
		else
			render action: "new"
		end
	end

	def draw_area
		@camp_details = Camp.get_camp_details([@camp])
	end

	def update
		if @camp.update(camp_params)

		    redirect_to camp_path(@camp), notice: "Successfully created a camp!"
		else

		    @camp_details = Camp.get_camp_details([@camp])
		    redirect_to draw_area_path(id: @camp.id)
		end		
	end


	def show
		@camp_details = Camp.get_camp_details([@camp])
		@camp_posts = @camp.posts.not_checkin.chronological.paginate(:page => params[:page])
		@camp_checkin = @camp.posts.checkin.chronological.paginate(:page => params[:page])
		@organizations = @camp.organizations
		@org_choices = @camp.org_choices
	end




	private
    # Use callbacks to share common setup or constraints between actions.
    def set_camp
      @camp = Camp.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def camp_params
      params.require(:camp).permit(:street_1, :street_2,:lat,:long, :latitude, :longitude, :zip, :city, :state,:name)
    end
end
