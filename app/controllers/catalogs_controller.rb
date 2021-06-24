class CatalogsController < ApplicationController
  before_action :authenticate_user!
  before_action :be_a_master, except: [:index, :show]
  load_and_authorize_resource
  before_action :set_catalog, only: [:show, :edit, :update, :destroy]
  autocomplete :lesson, :title, full: true, :display_value => :funky_method, extra_data: [:id]

  # GET /catalogs
  # GET /catalogs.json
  def index
    if current_user.has_role? :admin
      @catalogs = Catalog.all
    elsif session[:textbook_id]
      textbook_id = session[:textbook_id]
      @textbook = Textbook.find(textbook_id)
      if params[:order] == "length"
        lessons_id = @textbook.lessons.order(:content_length).pluck(:id)
        catalogs_id = Catalog.where(textbook_id: textbook_id, lesson_id: lessons_id).pluck(:id, :lesson_id)
        catalogs_order_length = []
        lessons_id.each do |i|
          catalogs_id.each do |j|
            if j[1] == i
              catalogs_order_length << j[0]
            end
          end
        end
        @catalogs = Kaminari.paginate_array(catalogs_order_length).page(params[:page]).per("100")
      else
        @catalogs = @textbook.catalogs.order(:serial).page(params[:page]).per("100")
      end
    else
      redirect_to textbooks_path, notice: "请先指定一本书。"
    end
  end

  # GET /catalogs/1
  # GET /catalogs/1.json
  def show
    if session[:textbook_id]
      @textbook = Textbook.find(session[:textbook_id])
      catalogs = @textbook.catalogs.order(:serial).pluck(:id)
      current_catalog_index = catalogs.index(@catalog.id)
      if current_catalog_index == 0
        @previous_catalog = nil
      else
        @previous_catalog = catalogs[current_catalog_index - 1]
      end
      if current_catalog_index == catalogs.size - 1
        @next_catalog = nil
      else
        @next_catalog = catalogs[current_catalog_index + 1]
      end
    end
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
        session[:new_catalog_serial] = @catalog.serial
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
        session[:new_catalog_serial] = @catalog.serial
        format.html { redirect_to @catalog, notice: "目录已被成功创建" }
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

  def quick_append
    if session[:textbook_id] && session[:lesson_id]
      @textbook = Textbook.find(session[:textbook_id])
      @lesson = Lesson.find(session[:lesson_id])
      if @textbook.user_id == current_user.id
        if @textbook.catalogs.any?
          last_catalog_serial = @textbook.catalogs.order(:serial).last.serial.to_f
          last_part = last_catalog_serial.to_s.partition(".")[2]
          if last_part == "0"
            catalog_serial = last_catalog_serial + 1
          else
            last_unit = last_part.size
            catalog_serial = (last_catalog_serial + (1.0/(10**last_unit))).round(last_unit)
          end
        else
          catalog_serial = 1
        end
        @catalog = Catalog.create{|c|
          c.serial = catalog_serial
          c.user_id = current_user.id
          c.textbook_id = @textbook.id
          c.lesson_id = @lesson.id
        }
        redirect_to @lesson, notice: "已经将这篇课文添加为《#{@textbook.title}》第 #{@catalog.serial.to_f} 课。"
      else
        redirect_to @lesson, notice: "您不能将这篇课文添加到《#{@textbook.title}》中。"
      end
    else
      redirect_to :@lesson, notice: "操作失败，您未指定课本或课文。"
    end
  end

  def export_all_lessons
    @book = Textbook.find_by(id: session[:textbook_id])
    @lessons_id = Catalog.where(textbook_id: @book.id).order(:serial).pluck(:lesson_id, :serial)
    file_name = @book.name + Time.now.to_s
    dir_name = @book.name + Time.now.to_s
    root_name = "public/data_export"
    path = File.join(root_name, dir_name)
    File.open(path, "wb"){ |f| 
      f.write
    }
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

    def be_a_master
      unless Master.find_by(user_id: current_user.id)
        redirect_back fallback_location: root_path, notice: "对不起，您暂时还没有老师的身份，无法进行操作。"
      end
    end

end
