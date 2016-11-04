class AgreementsController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource

  def like
    @agreement = Agreement.find_by(user_id: current_user.id,comment_id: params[:comment_id])
    unless @agreement
      Agreement.create(user_id: current_user.id, comment_id: params[:comment_id])
    end
    redirect_to :back, notice: "支持了一个评论"
  end

  def dislike
    @agreement = Agreement.find_by(user_id: current_user.id,comment_id: params[:comment_id])
    if @agreement
      @agreement.destroy
    end
    redirect_to :back, notice: "取消了一个赞成"
  end

  private

    # Never trust parameters from the scary internet, only allow the white list through.
    def agreement_params
      params.require(:agreement).permit(:user_id, :comment_id)
    end
end
