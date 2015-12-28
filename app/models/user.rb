class User < ActiveRecord::Base
  rolify
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :timeoutable
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
  has_many :onboards
  has_many :receipts
  has_many :cashiers
  has_many :withdraws
  has_many :quizzes
  has_many :quiz_items
  has_many :fees

  validates :active_time,  numericality: { only_integer: true, greater_than_or_equal_to: 0 }

end
