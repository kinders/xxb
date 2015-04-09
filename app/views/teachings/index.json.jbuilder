json.array!(@teachings) do |teaching|
  json.extract! teaching, :id, :user_id, :lesson_id, :title
  json.url teaching_url(teaching, format: :json)
end
