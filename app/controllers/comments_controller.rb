class CommentsController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource
  before_action :set_comment, only: [:show, :edit, :update, :destroy]

  # GET /comments
  # GET /comments.json
  def index
    unless current_user.has_role? :admin 
      redirect_to :back, notice: "无效操作"
      return
    end
    @comments = Comment.all
  end

  # GET /comments/1
  # GET /comments/1.json
  def show
    unless current_user.has_role? :admin 
      redirect_to :back, notice: "无效操作"
      return
    end
  end

  # GET /comments/new
  def new
    unless current_user.has_role? :admin 
      redirect_to :back, notice: "无效操作"
      return
    end
    @comment = Comment.new
  end

  # GET /comments/1/edit
  def edit
    unless current_user.has_role? :admin 
      redirect_to :back, notice: "无效操作"
      return
    end
  end

  # POST /comments
  # POST /comments.json
  def create
    unless session[:lesson_id] && session[:sentence_id]
      redirect_to :back, notice: "无法找到指定课程或者句子"
      return
    end
    @sentence = Sentence.find(session[:sentence_id])
    @comment = Comment.new(comment_params)
    @comment.user_id = current_user.id
    @comment.lesson_id = session[:lesson_id]
    @comment.sentence_id = @sentence.id
    word = Word.find_by(name: @sentence.name)
    if word
      word_id = word.id
    else
      word_id = @sentence.words.map{|w|[w.id, w.name]}.each {|w|w[0] if w[1].gsub(' ', '') == @sentence.name.gsub(' ', '') }
    end
    @comment.word_id = word_id

    respond_to do |format|
      if @comment.save
        format.html { redirect_to :back, notice: '添加评论成功！' }
        format.json { render :show, status: :created, location: @comment }
      else
        format.html { render :new }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /comments/1
  # PATCH/PUT /comments/1.json
  def update
    unless current_user.has_role? :admin 
      redirect_to :back, notice: "无效操作"
      return
    end
    respond_to do |format|
      if @comment.update(comment_params)
        format.html { redirect_to @comment, notice: 'Comment was successfully updated.' }
        format.json { render :show, status: :ok, location: @comment }
      else
        format.html { render :edit }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /comments/1
  # DELETE /comments/1.json
  def destroy
    @comment.destroy
    respond_to do |format|
      format.html { redirect_to comments_url, notice: 'Comment was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_comment
      @comment = Comment.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def comment_params
      params.require(:comment).permit(:user_id, :deleted_at, :content, :lesson_id, :sentence_id, :word_id)
    end
end
