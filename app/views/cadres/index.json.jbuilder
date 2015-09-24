json.array!(@cadres) do |cadre|
  json.extract! cadre, :id, :user_id, :position, :member_id, :deleted_at
  json.url cadre_url(cadre, format: :json)
end
