class MeController < ApplicationController
  skip_authorization_check
  before_action :authenticate_user!

  # 用来显示用户最近的活动记录。
  def summary
    @my_textbooks = Textbook.where(user_id: current_user.id)
    @my_lessons = Lesson.where(user_id: current_user.id)
    @my_tutors = Tutor.where(user_id: current_user.id)
    @my_practices = Practice.where(user_id: current_user.id)

    @ever_textbooks_ids = []
    his_textbook = History.where(user_id: current_user.id, modelname: "textbook").last(50)
    his_textbook.each {|h| @ever_textbooks_ids << h.entryid }
    @ever_textbooks = []
    @ever_textbooks_ids.each { |i| 
      if Textbook.exists?(i)
        @ever_textbooks << Textbook.find(i)
      end
    }
    @ever_textbooks.uniq!

    @ever_lessons_ids = []
    his_lessons = History.where(user_id: current_user.id, modelname: "lesson").last(50)
    his_lessons.each {|h| @ever_lessons_ids << h.entryid }
    @ever_lessons = []
    @ever_lessons_ids.each { |i| 
      if Lesson.exists?(i)
        @ever_lessons << Lesson.find(i)
      end
    }
    @ever_lessons.uniq!

    @ever_tutors_ids = []
    his_tutors = History.where(user_id: current_user.id, modelname: "tutor").last(50)
    his_tutors.each {|h| @ever_tutors_ids << h.entryid }
    @ever_tutors = []
    @ever_tutors_ids.each { |i| 
      if Tutor.exists?(i)
        @ever_tutors << Tutor.find(i) 
      end
    }
    @ever_tutors.uniq!
  end

  # 用来展示测试和积分。
  def  point_card
    @practices = Justice.where(evaluation_user_id: current_user.id).group(:practice_id).average(:score)
  end
  
  def justify
    # 显示其他人的的答卷，分为未评分和已评分两类。
    @all_evaluations = Evaluation.where.not(user_id:  current_user.id).order(updated_at: :desc)
    @evaluations = []
    @unjustified_evaluations = []
    @all_evaluations.each { |evaluation|
      if Justice.find_by(evaluation_id: evaluation.id) 
        unless Justice.find_by(user_id: 1, evaluation_id: evaluation.id)
          @evaluations << evaluation
	end
      else
        @unjustified_evaluations << evaluation
      end
    }
  end
end
