json.array!(@evaluations) do |evaluation|
  json.extract! evaluation, :id, :user_id, :tutor_id, :practice_id, :title, :question, :answer, :your_answer, :score
  json.url evaluation_url(evaluation, format: :json)
end
