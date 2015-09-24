json.array!(@exercises) do |exercise|
  json.extract! exercise, :id, :user_id, :tutor_id, :serial, :practice_id
  json.url exercise_url(exercise, format: :json)
end
