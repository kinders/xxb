class PapertestsController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource
  before_action :set_papertest, only: [:show, :edit, :update, :destroy]

  # GET /papertests
  # GET /papertests.json
  def index
    @papertests = Papertest.all
  end

  # GET /papertests/1
  # GET /papertests/1.json
  def show
  end

  # GET /papertests/new
  def new
    @papertest = Papertest.new
  end

  # GET /papertests/1/edit
  def edit
  end

  # POST /papertests
  # POST /papertests.json
  def create
    @papertest = Papertest.new(papertest_params)

    respond_to do |format|
      if @papertest.save
        format.html { redirect_to @papertest, notice: 'Papertest was successfully created.' }
        format.json { render :show, status: :created, location: @papertest }
      else
        format.html { render :new }
        format.json { render json: @papertest.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /papertests/1
  # PATCH/PUT /papertests/1.json
  def update
    respond_to do |format|
      if @papertest.update(papertest_params)
        format.html { redirect_to @papertest, notice: 'Papertest was successfully updated.' }
        format.json { render :show, status: :ok, location: @papertest }
      else
        format.html { render :edit }
        format.json { render json: @papertest.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /papertests/1
  # DELETE /papertests/1.json
  def destroy
    @papertest.destroy
    respond_to do |format|
      format.html { redirect_to papertests_url, notice: 'Papertest was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_papertest
      @papertest = Papertest.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def papertest_params
      params.require(:papertest).permit(:user_id, :paper_id, :end_at, :deleted_at)
    end
end
