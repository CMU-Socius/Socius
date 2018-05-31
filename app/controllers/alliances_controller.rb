class AlliancesController < ApplicationController
  authorize_resource

  before_action :set_alliance, only: [:show, :edit, :update, :destroy,:orgs]

  # GET /alliances
  # GET /alliances.json
  def index
    @alliances = Alliance.all
  end

  # GET /alliances/1
  # GET /alliances/1.json
  def show
    set_alliance
    @organizations = @alliance.organizations
    @org_choices = @alliance.org_choices
  end


  # GET /alliances/new
  def new
    @alliance = Alliance.new
  end

  # GET /alliances/1/edit
  def edit
  end

  # POST /alliances
  # POST /alliances.json
  def create
    @alliance = Alliance.new(alliance_params)

    respond_to do |format|
      if @alliance.save
        format.html { redirect_to @alliance, notice: 'Alliance was successfully created.' }
        format.json { render :show, status: :created, location: @alliance }
      else
        format.html { render :new }
        format.json { render json: @alliance.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /alliances/1
  # PATCH/PUT /alliances/1.json
  def update
    respond_to do |format|
      if @alliance.update(alliance_params)
        format.html { redirect_to @alliance, notice: 'Alliance was successfully updated.' }
        format.json { render :show, status: :ok, location: @alliance }
      else
        format.html { render :edit }
        format.json { render json: @alliance.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /alliances/1
  # DELETE /alliances/1.json
  def destroy
    @alliance.destroy
    respond_to do |format|
      format.html { redirect_to alliances_url, notice: 'Alliance was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def orgs
    @orgs = @alliance.organizations.alphabetical
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_alliance
      @alliance = Alliance.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def alliance_params
      params.require(:alliance).permit(:name)
    end
end
