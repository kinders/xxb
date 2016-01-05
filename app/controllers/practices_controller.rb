class PracticesController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource
  before_action :set_practice, only: [:show, :edit, :update, :destroy]
  before_action :be_a_master, except: [:index, :show]

  # GET /practices
  # GET /practices.json
  def index
    if current_user.has_role? :admin 
      @practices = Practice.all
    elsif session[:lesson_id]
      @lesson = Lesson.find(session[:lesson_id])
      if session[:tutor_id]
        @tutor = Tutor.find(session[:tutor_id])
        @practices = Practice.where(tutor_id: @tutor.id)
      else
        @practices = Practice.where(lesson_id: @lesson.id)
      end
    else
      redirect_to :back, notice: "需要指定课文。"
    end
  end

  # GET /practices/1
  # GET /practices/1.json
  def show
    history = History.create { |h| 
      h.user_id = current_user.id
      h.modelname = "practice"
      h.entryid = @practice.id
    }
    session[:practice_id] = @practice.id
    @lesson = Lesson.find_by(id: @practice.lesson_id)
    #@tutor = Tutor.find_by(id: @practice.tutor_id)
    @practices = Practice.where(lesson_id: session[:lesson_id])
    @practices.each_with_index do | practice, index |
      if practice == @practice
        if index - 1 < 0
	        @previous_practice = nil  
	      else
	        @previous_practice = @practices[index - 1] 
	      end
	      if index + 1 == @practices.length
	        @next_practice = nil
	      else
	        @next_practice = @practices[index + 1]
	      end
      end
    end
  end

  # GET /practices/new
  def new
    @practice = Practice.new
  end

  # GET /practices/1/edit
  def edit
  end

  # POST /practices
  # POST /practices.json
  def create
    @practice = Practice.new(practice_params)
    unless current_user.has_role? :admin
    @practice.user_id = current_user.id
    @practice.lesson_id = session[:lesson_id]
    @practice.score = (@practice.answer.to_s.gsub(/(<(\w|\/)+[^>]*>|\s)/, "").length.to_f / 10).ceil
    end
    respond_to do |format|
      if @practice.save
        format.html { redirect_to @practice, notice: "练习#{@practice.id}已经成功添加" }
        format.json { render :show, status: :created, location: @practice }
      else
        format.html { render :new }
        format.json { render json: @practice.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /practices/1
  # PATCH/PUT /practices/1.json
  def update
    unless current_user.has_role? :admin
    @practice.score = (@practice.answer.to_s.gsub(/(<(\w|\/)+[^>]*>|\s)/, "").length.to_f / 10).ceil
    end
    respond_to do |format|
      if @practice.update(practice_params)
        format.html { redirect_to @practice, notice: "练习#{@practice.id}已经更新成功" }
        format.json { render :show, status: :ok, location: @practice }
      else
        format.html { render :edit }
        format.json { render json: @practice.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /practices/1
  # DELETE /practices/1.json
  def destroy
    @practice.destroy
    respond_to do |format|
      format.html { redirect_to practices_url, notice: "练习#{@practice.id}已经被成功删除" }
      format.json { head :no_content }
    end
  end

  def delete_picture_q
    @practice = Practice.find(session[:practice_id])
    @practice.picture_q = nil
    @practice.save
    respond_to do |format|
      format.html { redirect_to :back, notice: "问题图片已经被删除" }
      format.json { head :no_content }
    end
  end

  def delete_picture_a
    @practice = Practice.find(session[:practice_id])
    @practice.picture_a = nil
    @practice.save
    respond_to do |format|
      format.html { redirect_to :back, notice: "答案图片已经被删除" }
      format.json { head :no_content }
    end
  end

  def create_practices_in_batch
    begin
      name =  current_user.name + Time.now.to_s
      directory = "public/data_import"
      path = File.join(directory, name)
      File.open(path, "wb") { |f| f.write(params[:csv_file].read) }
      data = SmarterCSV.process(path) do |allline|
        allline.each do |line|
          p = Practice.new 
          p.user_id = current_user.id
          p.lesson_id = session[:lesson_id]
          p.labelname = line[:标签]
          p.title = line[:标题]
          p.material = line[:材料]
          p.question = line[:问题]
          p.answer = line[:答案]
          p.score = line[:分值] || (p.answer.to_s.length.to_f / 10).ceil
          p.save!
        end
      end
      respond_to do |format|
        format.html { redirect_to practices_url, notice: '成功导入数据！' }
        format.json { head :no_content }
      end
    rescue 
      File.delete(path)
      respond_to do |format|
        format.html { redirect_to practices_url, notice: '导入数据失败，请修改CSV文件后重新尝试！' }
        format.json { head :no_content }
      end
    end
  end

  def add_to_paper
    @practice = Practice.find(params[:practice_id])
    if Paperitem.find_by(paper_id: session[:paper_id], practice_id: @practice.id)
      redirect_to :back, notice: "您之前已经将这道题添加到试卷中。"
      return
    else
      @paperitem = Paperitem.create{ |pi|
        pi.user_id = current_user.id
        pi.paper_id = session[:paper_id]
        pi.practice_id = @practice.id
        pi.score = @practice.score
      }
      redirect_to :back, notice: "成功将这道题添加到试卷中！"
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_practice
      @practice = Practice.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def practice_params
      params.require(:practice).permit(:title, :material, :question, :answer, :user_id, :tutor_id, :lesson_id, :activate, :score, :picture_q, :picture_a, :labelname)
    end

    def be_a_master
      unless Master.find_by(user_id: current_user.id)
        redirect_to :back, notice: "对不起，您暂时还没有老师的身份，无法进行操作。"
      end
    end

end
