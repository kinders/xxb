class MeController < ApplicationController
  skip_authorization_check
  before_action :authenticate_user!

  # 用来显示用户最近的活动记录。
  def summary
    ## 最近看过的资料：课本
=begin
    @ever_textbooks_ids = []
    his_textbook = History.where(user_id: current_user.id, modelname: "textbook").last(50)
    his_textbook.each {|h| @ever_textbooks_ids << h.entryid }
    ever_textbooks_ids.each { |i| 
      if Textbook.exists?(i)
        @ever_textbooks << Textbook.find(i)
      end
    }
    @ever_textbooks.uniq!
=end
    @ever_textbooks = []
    ever_textbooks_ids = History.where(user_id: current_user.id, modelname: "textbook").order(id: :desc).first(50).pluck(:entryid).uniq
    ever_textbooks = Textbook.where(id: ever_textbooks_ids)
    ever_textbooks_ids.each do |i|
      ever_textbooks.each do |j|
        if i == j.id
          @ever_textbooks << j
          break
        end
      end
    end
    ## 最近看过的资料：课程
=begin
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
=end
    @ever_lessons = []
    ever_lessons_ids = History.where(user_id: current_user.id, modelname: "lesson").order(id: :desc).first(50).pluck(:entryid).uniq
    ever_lessons = Lesson.where(id: ever_lessons_ids)
    ever_lessons_ids.each do |i|
      ever_lessons.each do |j|
        if i == j.id
          @ever_lessons << j
          break
        end
      end
    end
    ## 最近看过的资料：辅导
=begin
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
=end
    @ever_tutors = []
    ever_tutors_ids = History.where(user_id: current_user.id, modelname: "tutor").order(id: :desc).first(50).pluck(:entryid).uniq
    ever_tutors = Tutor.where(id: ever_tutors_ids)
    ever_tutors_ids.each do |i|
      ever_tutors.each do |j|
        if i == j.id
          @ever_tutors << j
          break
        end
      end
    end
    ## 最近玩过的卡片盒
    @my_cardboxes = Cardbox.where(user_id: current_user.id).last(10)
    ## 最近使用过的文路
    @my_roadmaps = Roadmap.where(user_id: current_user.id).last(10)
  end

  # 我的付款记录
  def my_receipts
    @active_time = current_user.active_time
    @receipts = Receipt.where(cashier: current_user.id).page params[:page]
  end

  def teacher_office
    # 自己制作的资料：课本，课程，辅导，练习
    @my_textbooks = Textbook.where(user_id: current_user.id).order(created_at: :desc)
    @my_lessons = Lesson.where(user_id: current_user.id).order(created_at: :desc)
    @my_tutors = Tutor.where(user_id: current_user.id).order(created_at: :desc)
    @my_practices = Practice.where(user_id: current_user.id).order(created_at: :desc)
  end

  # 用来展示测试和积分。
  def  point_card
    @practices = Justice.where(evaluation_user_id: current_user.id).group(:practice_id).average(:score)
  end
  
  def justify
    # 显示所有其他人的的答卷
    @all_evaluations = Evaluation.where.not(user_id:  current_user.id).order(updated_at: :desc)
    # 分为未评分和别人已评分两类。
    @evaluations = []
    @unjustified_evaluations = []
    @all_evaluations.each { |evaluation|
      justice = Justice.find_by(evaluation_id: evaluation.id) 
      if justice 
        if justice.user_id != 1 
          if justice.user_id != current_user.id
            @evaluations << evaluation
          end
	      end
      else
        if evaluation.end_at == nil
          @unjustified_evaluations << evaluation
        elsif evaluation.end_at < Time.now
          @unjustified_evaluations << evaluation
        end
      end
    }
  end

  def assign_homeworks
    
    if @teacher = Teacher.where(subject_id: 1, mentor: current_user.id).last
      @classroom = Classroom.find(@teacher.classroom_id)
      # 自己布置的作业
      @homeworks = Homework.where(user_id: current_user.id).order(created_at: :desc)
      if  @classroom.end == false
        # 所有老师布置的全班作业
        @class_homeworks = Homework.where.not(user_id: current_user.id).where(classroom_id: @teacher.classroom_id)
        # 所有老师布置的个别学生作业
        @student_homeworks = []
        @classroom.members.each { |member|
          h = Homework.where.not(user_id: current_user.id).where(student: member.student)#
          if h.any?
            @student_homeworks << h
            @student_homeworks.flatten!
          end
        }
      end
    else # 如果是普通教师，则显示自己布置的作业
      @homeworks = Homework.where(user_id: current_user.id).order(created_at: :desc)
    end
  end 
  
  # 显示我要完成的作业
  def my_homeworks
    @special_homeworks = Homework.where(student: current_user.id).order(created_at: :desc).to_a.delete_if { |hw| Observation.find_by(homework_id: hw.id, student: current_user.id) }
    @my_classrooms = []
    Classroom.where(end: false).each { |classroom|
      if classroom.members.where(student: current_user.id).any?
        @my_classrooms << classroom
      end
    }
    @my_classrooms.flatten!
    @class_homeworks = Homework.where(classroom_id: @my_classrooms).order(created_at: :desc).to_a.delete_if { |hw| Observation.find_by(homework_id: hw.id, student: current_user.id) }
  end

  # 显示当教师的班级
  def as_a_teacher
    @classrooms = []
    Classroom.where(end: false).each { |classroom|
      if classroom.teachers.where(mentor: current_user.id).any?
        @classrooms << classroom
      end
    }
    @classrooms.flatten!
  end

  # 显示当学生的班级
  def as_a_student
    @classrooms = []
    Classroom.where(end: false).each { |classroom|
      if classroom.members.where(student: current_user.id).any?
        @classrooms << classroom
      end
    }
    @classrooms.flatten!
  end

  def seed_user
    CSV.foreach("csvfile") do |row|
      User.create{ |u|
	      u.name = row[0].to_s
	      u.email = row[1].to_s
	      u.encrypted_password = "$2a$10$gU9lYlmq5EG4TB/S27qpAOlKavks8giogS5qt9NLrauQ58M0955Ha"  # 默认密码123456789
      }
    end
  end

end
