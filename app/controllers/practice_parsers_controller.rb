class PracticeParsersController < ApplicationController
  skip_before_action :check_user_active_time
  skip_authorization_check
  before_action :set_practice_parser, only: [:show, :edit, :update, :destroy]

=begin
  # GET /practice_parsers
  # GET /practice_parsers.json
  def index
    @practice_parsers = PracticeParser.all
  end

  # GET /practice_parsers/1
  # GET /practice_parsers/1.json
  def show
  end

  # GET /practice_parsers/new
  def new
    @practice_parser = PracticeParser.new
  end

  # GET /practice_parsers/1/edit
  def edit
  end

  # POST /practice_parsers
  # POST /practice_parsers.json
  def create
    @practice_parser = PracticeParser.new(practice_parser_params)

    respond_to do |format|
      if @practice_parser.save
        format.html { redirect_to @practice_parser, notice: 'Practice parser was successfully created.' }
        format.json { render :show, status: :created, location: @practice_parser }
      else
        format.html { render :new }
        format.json { render json: @practice_parser.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /practice_parsers/1
  # PATCH/PUT /practice_parsers/1.json
  def update
    respond_to do |format|
      if @practice_parser.update(practice_parser_params)
        format.html { redirect_to @practice_parser, notice: 'Practice parser was successfully updated.' }
        format.json { render :show, status: :ok, location: @practice_parser }
      else
        format.html { render :edit }
        format.json { render json: @practice_parser.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /practice_parsers/1
  # DELETE /practice_parsers/1.json
  def destroy
    @practice_parser.destroy
    respond_to do |format|
      format.html { redirect_to practice_parsers_url, notice: 'Practice parser was successfully destroyed.' }
      format.json { head :no_content }
    end
  end
=end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_practice_parser
      @practice_parser = PracticeParser.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def practice_parser_params
      params.require(:practice_parser).permit(:practice_id, :word_id, :deleted_at)
    end
end
