class CampOrgsController < ApplicationController

	def create
	    @camp_org = CampOrg.new(camp_org_params)
	    if @camp_org.save
	      flash[:notice] = "Successfully share this camp with #{@camp_org.organization.name}"
	      redirect_to camp_path(@camp_org.camp)   
	    end
	end


	def camp_org_params
		params.require(:camp_org).permit(:camp_id, :organization_id)
	end
end
