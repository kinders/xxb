json.array!(@sentences) do |sentence|
  json.extract! sentence, :id, :lesson_id, :name, :deleted_at
  json.url sentence_url(sentence, format: :json)
end
