json.array!(@players) do |player|
  json.extract! player, :id, :user_id, :team_id, :member_id, :deleted_at
  json.url player_url(player, format: :json)
end
