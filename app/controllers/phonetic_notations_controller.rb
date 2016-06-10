class PhoneticNotationsController < ApplicationController
  skip_before_action :check_user_active_time
  skip_authorization_check
  before_action :set_phonetic_notation, only: [:show, :edit, :update, :destroy]

  # GET /phonetic_notations
  # GET /phonetic_notations.json
  def index
    @phonetic_notations = PhoneticNotation.all.order("id").page(params[:page]).per('10')
  end

  # GET /phonetic_notations/1
  # GET /phonetic_notations/1.json
  def show
    @word = Word.find(session[:word_id])
  end

  # GET /phonetic_notations/new
  def new
    @phonetic_notation = PhoneticNotation.new
  end

  # GET /phonetic_notations/1/edit
  def edit
  end

  # POST /phonetic_notations
  # POST /phonetic_notations.json
  def create
    @phonetic_notation = PhoneticNotation.new(phonetic_notation_params)

    respond_to do |format|
      if @phonetic_notation.save
        format.html { redirect_to @phonetic_notation, notice: 'Phonetic notation was successfully created.' }
        format.json { render :show, status: :created, location: @phonetic_notation }
      else
        format.html { render :new }
        format.json { render json: @phonetic_notation.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /phonetic_notations/1
  # PATCH/PUT /phonetic_notations/1.json
  def update
    respond_to do |format|
      if @phonetic_notation.update(phonetic_notation_params)
        format.html { redirect_to @phonetic_notation, notice: 'Phonetic notation was successfully updated.' }
        format.json { render :show, status: :ok, location: @phonetic_notation }
      else
        format.html { render :edit }
        format.json { render json: @phonetic_notation.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /phonetic_notations/1
  # DELETE /phonetic_notations/1.json
  def destroy
    @phonetic_notation.destroy
    respond_to do |format|
      format.html { redirect_to :back, notice: '已经删除该注音方案' }
      # format.html { redirect_to phonetic_notations_url, notice: 'Phonetic notation was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_phonetic_notation
      @phonetic_notation = PhoneticNotation.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def phonetic_notation_params
      params.require(:phonetic_notation).permit(:phonetic_id, :word_id, :deleted_at)
    end
end
