class PropositionsController < ApplicationController

  before_action :authenticate_user!
  before_action :set_proposition, only: [:show, :edit, :update, :destroy]

  # GET /propositions
  # GET /propositions.json
  def index
    @propositions = Proposition.where(:user_id => current_user.id)
  end

  # GET /propositions/1
  # GET /propositions/1.json
  def show
  end

  # GET /propositions/new
  def new
    @proposition = Proposition.new
    @proposition.user_id = current_user.id
  end

  # GET /propositions/1/edit
  def edit
  end

  # POST /propositions
  # POST /propositions.json
  def create
    @proposition = Proposition.new(proposition_params)
    @proposition.user_id = current_user.id

    respond_to do |format|
      if @proposition.save
        format.html { redirect_to @proposition, notice: 'Proposition was successfully created.' }
        format.json { render :show, status: :created, location: @proposition }
      else
        format.html { render :new }
        format.json { render json: @proposition.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /propositions/1
  # PATCH/PUT /propositions/1.json
  def update
    respond_to do |format|
      if @proposition.update(proposition_params)
        format.html { redirect_to @proposition, notice: 'Proposition was successfully updated.' }
        format.json { render :show, status: :ok, location: @proposition }
      else
        format.html { render :edit }
        format.json { render json: @proposition.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /propositions/1
  # DELETE /propositions/1.json
  def destroy
    @proposition.destroy
    respond_to do |format|
      format.html { redirect_to propositions_url, notice: 'Proposition was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_proposition
      @proposition = Proposition.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def proposition_params
      params.require(:proposition).permit(:name)
    end

end
