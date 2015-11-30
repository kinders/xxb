json.array!(@teams) do |team|
  json.extract! team, :id, :user_id, :sectionalization_id, :name, :deleted_at
  json.url team_url(team, format: :json)
end
