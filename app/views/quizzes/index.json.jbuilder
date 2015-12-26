json.array!(@quizzes) do |quiz|
  json.extract! quiz, :id, :user_id, :cardbox_id, :title, :number, :repetition, :duration, :deleted_at
  json.url quiz_url(quiz, format: :json)
end
