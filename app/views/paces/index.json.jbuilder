json.array!(@paces) do |pace|
  json.extract! pace, :id, :user_id, :roadmap_id, :lesson_id, :serial, :deleted_at
  json.url pace_url(pace, format: :json)
end
