json.array!(@members) do |member|
  json.extract! member, :id, :serial, :user, :classroom_id, :deleted_at
  json.url member_url(member, format: :json)
end
