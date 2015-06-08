json.array!(@observations) do |observation|
  json.extract! observation, :id, :user_id, :student, :point, :mark, :deleted_at, :homework_id
  json.url observation_url(observation, format: :json)
end
