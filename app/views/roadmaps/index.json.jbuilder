json.array!(@roadmaps) do |roadmap|
  json.extract! roadmap, :id, :name, :description, :user_id, :deleted_at
  json.url roadmap_url(roadmap, format: :json)
end
