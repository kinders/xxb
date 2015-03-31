json.array!(@practices) do |practice|
  json.extract! practice, :id, :title, :question, :answer, :user_id, :tutor_id, :lesson_id, :activate
  json.url practice_url(practice, format: :json)
end
