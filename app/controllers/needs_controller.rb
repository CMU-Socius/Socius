class NeedsController < ApplicationController

    before_action :check_login, except: [:new, :create]
    load_and_authorize_resource

    def index
        @needs = Need.all.to_a
    end

    def create
        @need = Need.new
    end

    def new
        @need = Need.new
        if @need.save!
		    redirect_to posts_path, notice: "Successfully added new user: #{@user.username}."
	    
        else
		    render action: 'new'
	    end
    end

    def edit
    end
    
    def update
        if @need.update(need_params)
            redirect_to need_path(@need), notice: "Successfully updated #{@need.name}"
        else
            render action: "edit"
        end
    end

  

    private

    def set_need
        @need = Need.find(params[:id])
    end

    def need_params
        params.require(:need).permit(:name)
    end


end
