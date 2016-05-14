class WordParsersController < ApplicationController
  skip_before_action :check_user_active_time
  skip_authorization_check
  before_action :set_word_parser, only: [:show, :edit, :update, :destroy]

  # GET /word_parsers
  # GET /word_parsers.json
  # def index
    # @word_parsers = WordParser.all
  # end

  # GET /word_parsers/1
  # GET /word_parsers/1.json
  # def show
  # end

  # GET /word_parsers/new
  # def new
    # @word_parser = WordParser.new
  # end

  # GET /word_parsers/1/edit
  # def edit
  # end

  # POST /word_parsers
  # POST /word_parsers.json
  # def create
    # @word_parser = WordParser.new(word_parser_params)

    # respond_to do |format|
      # if @word_parser.save
        # format.html { redirect_to @word_parser, notice: 'Word parser was successfully created.' }
        # format.json { render :show, status: :created, location: @word_parser }
      # else
        # format.html { render :new }
        # format.json { render json: @word_parser.errors, status: :unprocessable_entity }
      # end
    # end
  # end

  # PATCH/PUT /word_parsers/1
  # PATCH/PUT /word_parsers/1.json
  # def update
    # respond_to do |format|
      # if @word_parser.update(word_parser_params)
        # format.html { redirect_to @word_parser, notice: 'Word parser was successfully updated.' }
        # format.json { render :show, status: :ok, location: @word_parser }
      # else
        # format.html { render :edit }
        # format.json { render json: @word_parser.errors, status: :unprocessable_entity }
      # end
    # end
  # end

  # DELETE /word_parsers/1
  # DELETE /word_parsers/1.json
  # def destroy
    # @word_parser.destroy
    # respond_to do |format|
      # format.html { redirect_to word_parsers_url, notice: 'Word parser was successfully destroyed.' }
      # format.json { head :no_content }
    # end
  # end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_word_parser
      @word_parser = WordParser.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def word_parser_params
      params.require(:word_parser).permit(:word_id, :lesson_id, :deleted_at)
    end
end
