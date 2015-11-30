json.array!(@classgroupscores) do |classgroupscore|
  json.extract! classgroupscore, :id, :user_id, :team_id, :score, :domain, :memo, :deleted_at
  json.url classgroupscore_url(classgroupscore, format: :json)
end
