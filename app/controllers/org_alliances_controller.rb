class OrgAlliancesController < ApplicationController

  def create
    @org_alliance = OrgAlliance.new(org_alliance_params)
    if @org_alliance.save
      flash[:notice] = "Successfully added #{@org_alliance.organization.name} to this alliance."
      redirect_to alliance_path(@org_alliance.alliance)   
    end
  end

  def destroy
    alliance_id = params[:id]
    organization_id = params[:organization_id]
    @org_alliance = OrgAlliance.where(organization_id: organization_id, alliance_id: alliance_id).first
    unless @org_alliance.nil?
      @org_alliance.destroy
      redirect_to alliance_path(@org_alliance.alliance) 
      flash[:notice] = "Successfully removed this organizaiton."
    end
  end


  private


  def org_alliance_params
        params.require(:org_alliance).permit(:organization_id, :alliance_id)
  end

end
