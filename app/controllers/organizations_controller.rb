class OrganizationsController < ApplicationController

	authorize_resource

	def index
		authorize! :manage, :all
		@organizations = Organization.all.alphabetical
	end

	def show
		set_organization
		@alliances = @organization.alliances
	end

	def edit
		set_organization
	end

	def update
		set_organization
		if @organization.update(organization_params)
      redirect_to organization_path(@organization), notice: "Successfully updated #{@organization.name}"
    else
      render action: "edit"
    end
	end

	def new
		@organization = Organization.new
	end

	def create
		@organization = Organization.new(organization_params)
		if @organization.save
			redirect_to organizations_path, notice: "Successfully added new organization: #{@organization.name}."
		else
			render action: 'new'
		end
	end

	private
	def set_organization
		@organization = Organization.find(params[:id])
	end

	def organization_params
		params.require(:organization).permit(:name, :active)
	end

end
