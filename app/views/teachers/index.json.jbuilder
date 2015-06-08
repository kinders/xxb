json.array!(@teachers) do |teacher|
  json.extract! teacher, :id, :user_id, :classroom_id, :mentor, :deleted_at
  json.url teacher_url(teacher, format: :json)
end
