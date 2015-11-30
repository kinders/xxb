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
  has_many :cadres
  has_many :complaints
  has_many :homeworks
  has_many :observations
  has_many :teachers
  has_many :exercises
  has_many :cardboxes
  has_many :cards
  has_many :sectionalizations
  has_many :teams
  has_many :players

end
