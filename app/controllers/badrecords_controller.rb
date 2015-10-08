class BadrecordsController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource
  before_action :set_badrecord, only: [:show, :edit, :update, :destroy]

  # GET /badrecords
  # GET /badrecords.json
  def index
    if current_user.has_role? :admin
      @badrecords = Badrecord.all
    else
      @classroom = Classroom.find(session[:classroom_id])
      @badrecords_by_me = Badrecord.where(user_id: current_user.id, classroom_id: @classroom.id, finish: nil).order(:troublemaker) # 管理
      if @classroom.teachers.find_by(mentor: current_user.id)  # 教师
        @class_badrecords = Badrecord.where(classroom_id: @classroom.id, finish: nil).order(:troublemaker)
      else
        @class_badrecords = []  # 为了在视图中统一使用any?方法。
      end
      # 自己的不良记录列表移动到member模块。
    end
  end

  # GET /badrecords/1
  # GET /badrecords/1.json
  def show
  end

  # GET /badrecords/new
  def new
    @classroom = Classroom.find(session[:classroom_id])  if session[:classroom_id]
    @badrecord = Badrecord.new
  end

  # GET /badrecords/1/edit
  def edit
    @classroom = Classroom.find(session[:classroom_id])  if session[:classroom_id]
  end

  # POST /badrecords
  # POST /badrecords.json
  def create
    badrecord_params[:troublemaker].to_a.each { |p|
      next if p == ""
      @badrecord = Badrecord.new { |b|
        b.troublemaker = p
        b.user_id = current_user.id
        b.classroom_id = session[:classroom_id] if session[:classroom_id]
        b.troubletime = Time.new(badrecord_params["troubletime(1i)"], badrecord_params["troubletime(2i)"], badrecord_params["troubletime(3i)"])
        b.subject_id = badrecord_params[:subject_id]
        b.description = badrecord_params[:description]
      }
      @badrecord.save!
    }
    respond_to do |format|
        format.html { redirect_to badrecords_url, notice: '成功添加不良记录' }
    end
=begin
    respond_to do |format|
      if @badrecord.save
        format.html { redirect_to @badrecord, notice: '成功添加一条不良记录' }
        format.json { render :show, status: :created, location: @badrecord }
      else
        format.html { render :new }
        format.json { render json: @badrecord.errors, status: :unprocessable_entity }
      end
    end
=end
  end

  # PATCH/PUT /badrecords/1
  # PATCH/PUT /badrecords/1.json
  def update
    @classroom = Classroom.find(session[:classroom_id])  if session[:classroom_id]
    respond_to do |format|
      if @badrecord.update(badrecord_params)
        format.html { redirect_to @badrecord, notice: 'Badrecord was successfully updated.' }
        format.json { render :show, status: :ok, location: @badrecord }
      else
        format.html { render :edit }
        format.json { render json: @badrecord.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /badrecords/1
  # DELETE /badrecords/1.json
  def destroy
    @badrecord.destroy
    respond_to do |format|
      format.html { redirect_to badrecords_url, notice: 'Badrecord was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  # GET /badrecords/1/finish_badrecord
  def finish_badrecord
    @badrecord = Badrecord.find(params[:badrecord_id])
    @badrecord.finish_man = current_user.id
    @badrecord.finish_time = Time.now
    @badrecord.update(finish: true)
    respond_to do |format|
      format.html { redirect_to :back, notice: '成功抹平一条不良记录。' }
      format.json { head :no_content }
    end
  end

  def download_csv
    @classroom = Classroom.find(session[:classroom_id])
    @class_badrecords = Badrecord.where(classroom_id: @classroom.id, finish: nil).order(:troublemaker)
    @output_encoding = "UTF-8"
    respond_to do |format|
      format.csv # make sure you have action_name.csv.csvbuilder template in place
    end 
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_badrecord
      @badrecord = Badrecord.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def badrecord_params
      params.require(:badrecord).permit(:user_id, {troublemaker: []}, :classroom_id, :troubletime, :subject_id, :description, :finish, :finish_man, :finish_time, :deleted_at)
    end
end
