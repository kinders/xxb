class User < ActiveRecord::Base
  rolify
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  has_many :textbooks
  has_many :catalogs
  has_many :lessons
  has_many :teachings
  has_many :plans
  has_many :tutors
  has_many :practices
  has_many :evaluations
  has_many :justices
  has_many :classrooms
  has_many :members
  has_many :complaints
  has_many :homeworks
  has_many :observations
  has_many :teachers

end
