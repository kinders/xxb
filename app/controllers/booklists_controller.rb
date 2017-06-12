class BooklistsController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource
  before_action :set_booklist, only: [:show, :edit, :update, :destroy]

  # GET /booklists
  # GET /booklists.json
  def index
    if current_user.has_role? :admin
      @booklists = Booklist.all
    else
      @booklists = Booklist.where(user_id: current_user.id).order(:serial)
    end
  end

=begin
  # GET /booklists/1
  # GET /booklists/1.json
  def show
  end
=end

  # GET /booklists/new
  def new
    unless session[:textbook_id]
      redirect_to :back, notice: '无法找到指定的图书'
      return
    end
    @textbook = Textbook.find_by(id: session[:textbook_id])
    @booklist = Booklist.new
  end

  # GET /booklists/1/edit
  def edit
  end

  # POST /booklists
  # POST /booklists.json
  def create
    unless session[:textbook_id]
      redirect_to :back, notice: '无法找到指定的图书'
      return
    end
    @booklist = Booklist.new(booklist_params)
    @booklist.user_id = current_user.id
    @booklist.textbook_id = session[:textbook_id]

    respond_to do |format|
      if @booklist.save
        format.html { redirect_to booklists_path, notice: '成功添加书单' }
        format.json { render :show, status: :created, location: @booklist }
      else
        format.html { render :new }
        format.json { render json: @booklist.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /booklists/1
  # PATCH/PUT /booklists/1.json
  def update
    respond_to do |format|
      if @booklist.update(booklist_params)
        format.html { redirect_to booklists_path, notice: '成功更新书单' }
        format.json { render :show, status: :ok, location: @booklist }
      else
        format.html { render :edit }
        format.json { render json: @booklist.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /booklists/1
  # DELETE /booklists/1.json
  def destroy
    @booklist.destroy
    respond_to do |format|
      format.html { redirect_to booklists_url, notice: '成功删除书单' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_booklist
      @booklist = Booklist.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def booklist_params
      params.require(:booklist).permit(:user_id, :textbook_id, :serial, :deleted_at)
    end
end
