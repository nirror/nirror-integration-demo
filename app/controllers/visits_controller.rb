class VisitsController < ApplicationController

  before_filter :load_proposition
  before_action :set_visit, only: [:show, :edit, :update, :destroy]

  # GET /propositions/1/visits
  # GET /propositions/1/visits.json
  def index
    @visits = @proposition.visits.all
  end

  # GET /propositions/1/visits/1
  # GET /propositions/1/visits/1.json
  def show
    @token = current_user.request_nirror_token
  end

  # GET /propositions/1/visits/new
  def new
    @visit = @proposition.visits.new
  end

  # GET /propositions/1/visits/1/edit
  def edit
  end

  # POST /propositions/1/visits
  # POST /propositions/1/visits.json
  def create
    @visit = @proposition.visits.where(visit_params).first_or_create

    respond_to do |format|
      if @visit.save
        format.html { redirect_to [@proposition, @visit], notice: 'Visit was successfully created.' }
        format.json { render :show, status: :created, location: @visit }
      else
        format.html { render :new }
        format.json { render json: @visit.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /propositions/1/visits/1
  # PATCH/PUT /propositions/1/visits/1.json
  def update
    respond_to do |format|
      if @visit.update(visit_params)
        format.html { redirect_to [@proposition, @visit], notice: 'Visit was successfully updated.' }
        format.json { render :show, status: :ok, location: @visit }
      else
        format.html { render :edit }
        format.json { render json: @visit.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /propositions/1/visits/1
  # DELETE /propositions/1/visits/1.json
  def destroy
    @visit.destroy
    respond_to do |format|
      format.html { redirect_to proposition_visits_url, notice: 'Visit was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_visit
      @visit = Visit.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def visit_params
      params.require(:visit).permit(:nirror_hash_path)
    end

    def load_proposition
      @proposition = Proposition.find(params[:proposition_id])
    end
end
