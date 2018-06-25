class CampsController < ApplicationController
	before_action :set_camp, only: [:draw_area,:update,:show]

	def new
		@camp = Camp.new
	end
	def create
		@camp = Camp.new(camp_params)
		if @camp.save
			redirect_to draw_area_path(id: @camp.id),notice: "Successfully created a camp"
		else
			render action: "new"
		end
	end

	def draw_area
		@camp_details = Camp.get_camp_details([@camp])
	end

	def update

		if @camp.update(camp_params)

		    redirect_to camp_path(@camp), notice: "Successfully updated #{@camp.name}"
		else

		    @camp_details = Camp.get_camp_details([@camp])
		    redirect_to draw_area_path(id: @camp.id)
		end		
	end


	def show
		@camp_details = Camp.get_camp_details([@camp])
		@camp_posts = ""
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
