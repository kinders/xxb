class CatalogsController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource
  before_action :set_catalog, only: [:show, :edit, :update, :destroy]
  #autocomplete :lesson, :id, full: true, extra_data: [:title]

  # GET /catalogs
  # GET /catalogs.json
  def index
    if current_user.has_role? :admin
      @catalogs = Catalog.all
    else
      textbook_id = session[:textbook_id]
      @textbook = Textbook.find(textbook_id)
      @catalogs = @textbook.catalogs.order(:serial)
    end
  end

  # GET /catalogs/1
  # GET /catalogs/1.json
  def show
  end

  # GET /catalogs/new
  def new
    @catalog = Catalog.new
  end

  # GET /catalogs/1/edit
  def edit
  end

  # POST /catalogs
  # POST /catalogs.json
  def create
    @catalog = Catalog.new(catalog_params)
    @catalog.textbook_id = session[:textbook_id]
    @catalog.user_id = current_user.id

    respond_to do |format|
      if @catalog.save
        format.html { redirect_to @catalog, notice: "目录已被成功创建" }
        format.json { render :show, status: :created, location: @catalog }
      else
        format.html { render :new }
        format.json { render json: @catalog.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /catalogs/1
  # PATCH/PUT /catalogs/1.json
  def update
    respond_to do |format|
      if @catalog.update(catalog_params)
        format.html { redirect_to @catalog, notice: "目录已经成功更新" }
        format.json { render :show, status: :ok, location: @catalog }
      else
        format.html { render :edit }
        format.json { render json: @catalog.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /catalogs/1
  # DELETE /catalogs/1.json
  def destroy
    @catalog.destroy
    respond_to do |format|
      format.html { redirect_to catalogs_url, notice: "目录已被成功删除" }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_catalog
      @catalog = Catalog.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def catalog_params
      params.require(:catalog).permit(:serial, :user_id, :textbook_id, :lesson_id)
    end
end
