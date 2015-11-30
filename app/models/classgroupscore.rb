class Classgroupscore < ActiveRecord::Base
  belongs_to :user
  belongs_to :team
  has_many :classpersonscores, dependent: :destroy
  resourcify
  acts_as_paranoid
  validates :user_id, :team_id, :score, :domain,:memo,  presence: true
end
