class DiscussionsController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource
  before_action :set_discussion, only: [:show, :edit, :update, :destroy]

  # GET /discussions
  # GET /discussions.json
  def index
    if current_user.has_role? :admin
      @discussions = Discussion.all
    else
      @classroom = Classroom.find(session[:classroom_id])
      @discussions = Discussion.where(end_at: nil, is_ready: true, classroom_id: @classroom.id)
      @not_ready_discussions = Discussion.where(end_at: nil, is_ready: false)
    end
  end

  # GET /discussions/1
  # GET /discussions/1.json
  def show
    session[:discussion_id] = @discussion.id
    session[:classroom_id] = @discussion.classroom_id
    session[:textbook_id] = @discussion.textbook_id
    session[:lesson_id] = @discussion.lesson_id
    session[:teaching_id] = @discussion.teaching_id
  end

  # GET /discussions/new
  def new
    @discussion = Discussion.new
  end

  # GET /discussions/1/edit
  def edit
  end

  # POST /discussions
  # POST /discussions.json
  def create
    @discussion = Discussion.new(discussion_params)
    unless current_user.has_role? :admin
      @discussion.user_id = current_user.id
    end

    respond_to do |format|
      if @discussion.save
        unless @discussion.lesson_id
	  format.html { redirect_to edit_discussion_path(@discussion), notice: "第二步，选择课程"}
        else
        format.html { redirect_to @discussion, notice: '课堂已经就绪' }
        format.json { render :show, status: :created, location: @discussion }
        end
      else
        format.html { render :new }
        format.json { render json: @discussion.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /discussions/1
  # PATCH/PUT /discussions/1.json
  def update
    respond_to do |format|
      if @discussion.update(discussion_params)
        unless  @discussion.teaching_id
	  format.html { redirect_to edit_discussion_path(@discussion), notice: "第三步，选择教法"}
        else
        @discussion.is_ready = true
        @discussion.save
        format.html { redirect_to @discussion, notice: '课堂准备就绪' }
        format.json { render :show, status: :ok, location: @discussion }
        end
      else
        format.html { render :edit }
        format.json { render json: @discussion.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /discussions/1
  # DELETE /discussions/1.json
  def destroy
    @discussion.destroy
    respond_to do |format|
      format.html { redirect_to discussions_url, notice: 'Discussion was successfully destroyed.' }
      format.json { head :no_content }
    end
  end
  
  def end_discussion
    @discussion = Discussion.find(session[:discussion_id])
    @discussion.end_at = Time.now
    @discussion.save
    session[:discussion_id] = nil
    respond_to do |format|
      format.html { redirect_to discussions_url, notice: '课堂结束！' }
      format.json { head :no_content }
    end
  end
  
  def quit_discussion
    session[:discussion_id] = nil
    respond_to do |format|
      format.html { redirect_to discussions_path, notice: '已经从课堂中退出！' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_discussion
      @discussion = Discussion.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def discussion_params
      params.require(:discussion).permit(:user_id, :classroom_id, :textbook_id, :lesson_id, :teaching_id, :end, :end_at, :is_ready, :deleted_at)
    end
end
