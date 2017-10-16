class AnalyzePracticeJob < ActiveJob::Base
  queue_as :default

  def perform(practice_id)
    Practice.find(practice_id).analysis_practice
  end
end
