class TextbooksController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource
  before_action :set_textbook, only: [:show, :edit, :update, :destroy]

  # GET /textbooks
  # GET /textbooks.json
  def index
    @textbooks = Textbook.all.order(:serial)
  end

  # GET /textbooks/1
  # GET /textbooks/1.json
  def show
    history = History.create { |h| 
      h.user_id = current_user.id
      h.modelname = "textbook"
      h.entryid = @textbook.id
    }
    session[:textbook_id] = @textbook.id
    unless current_user.has_role? :admin
      respond_to do |format|
        format.html { redirect_to catalogs_path }
      end
    end
  end

  # GET /textbooks/new
  def new
    @textbook = Textbook.new
  end

  # GET /textbooks/1/edit
  def edit
  end

  # POST /textbooks
  # POST /textbooks.json
  def create
    @textbook = Textbook.new(textbook_params)
    unless current_user.has_role? :admin
      @textbook.user_id = current_user.id
    end
    respond_to do |format|
      if @textbook.save
        format.html { redirect_to @textbook, notice: "教科书已被成功创建" }
        format.json { render :show, status: :created, location: @textbook }
      else
        format.html { render :new }
        format.json { render json: @textbook.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /textbooks/1
  # PATCH/PUT /textbooks/1.json
  def update
    unless current_user.has_role? :admin
      @textbook.user_id = current_user.id
    end
    respond_to do |format|
      if @textbook.update(textbook_params)
        format.html { redirect_to @textbook, notice: "教科书已被成功更新" }
        format.json { render :show, status: :ok, location: @textbook }
      else
        format.html { render :edit }
        format.json { render json: @textbook.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /textbooks/1
  # DELETE /textbooks/1.json
  def destroy
    @textbook.destroy
    respond_to do |format|
      format.html { redirect_to textbooks_url, notice: "教科书已被成功删除" }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_textbook
      @textbook = Textbook.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def textbook_params
      params.require(:textbook).permit(:title, :description, :serial, :user_id)
    end
end
