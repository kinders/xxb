json.array!(@classpersonscores) do |classpersonscore|
  json.extract! classpersonscore, :id, :user_id, :member_id, :score, :classgroupscore_id, :deleted_at
  json.url classpersonscore_url(classpersonscore, format: :json)
end
