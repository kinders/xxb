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
      # 自己管理的不良记录
      @badrecords_by_me = Badrecord.where(user_id: current_user.id, classroom_id: @classroom.id, finish: nil, troublemaker: @classroom.members.map{|m|m.student}).order(:troublemaker) 
      @badrecords_finish_by_me = Badrecord.where(user_id: current_user.id, classroom_id: @classroom.id, finish: true, troublemaker: @classroom.members.map{|m|m.student}).order(:troublemaker) 
      # 班级的不良记录移动到classroom的class_badrecords模块。
      # 自己的不良记录列表移动到member的show模块。
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
    begin
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
    rescue 
      respond_to do |format|
        format.html { redirect_back fallback_location: root_path, notice: '不良记录添加失败，请先检查哪些记录没有添加。' }
        format.json { render json: @card.errors, status: :unprocessable_entity }
      end
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
        if session[:member_id]
          format.html { redirect_to member_url(session[:member_id]), notice: 'Badrecord was successfully updated.' }
          format.json { render :show, status: :ok, location: @badrecord }
        else
          format.html { redirect_to badrecords_url, notice: 'Badrecord was successfully updated.' }
          format.json { render :show, status: :ok, location: @badrecord }
        end
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
    @badrecord.update(finish_man: current_user.id, finish_time: Time.now, finish: true)
    respond_to do |format|
      format.html { redirect_back fallback_location: root_path, notice: "成功抹平一条不良记录（#{@badrecord.id}）。" }
      format.json { head :no_content }
    end
  end

  # POST /badrecords/finish_badrecords_in_batch
  def finish_badrecords_in_batch
    @badrecords = Badrecord.where(id: params[:badrecord_id])
    @badrecords.update_all(finish_man: current_user.id, finish_time: Time.now, finish: true)
    respond_to do |format|
      format.html { redirect_back fallback_location: root_path, notice: "成功抹平以下不良记录：#{@badrecords.map{|badrecord| badrecord.id }}。"} 
      format.json { head :no_content }
    end
  end

  # GET /badrecords/1/restore_badrecord
  def restore_badrecord
    @badrecord = Badrecord.find(params[:badrecord_id])
    @badrecord.update(finish_man: nil, finish_time: nil, finish: nil)
    respond_to do |format|
      format.html { redirect_back fallback_location: root_path, notice: '还原了一条不良记录。' }
      format.json { head :no_content }
    end
  end

  def download_csv
    @classroom = Classroom.find(session[:classroom_id])
    @class_badrecords = Badrecord.where(classroom_id: @classroom.id, finish: nil, troublemaker: @classroom.members.map{|m|m.student}).order(:troublemaker)
    @filename = "#{@classroom.name}不良记录#{Time.now.to_formatted_s(:number)}.csv"
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
      params.require(:badrecord).permit(:user_id, {troublemaker: []}, {id: []}, :classroom_id, :troubletime, :subject_id, :description, :finish, :finish_man, :finish_time, :deleted_at)
    end
end
