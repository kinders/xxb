json.array!(@masters) do |master|
  json.extract! master, :id, :user_id, :deleted_at
  json.url master_url(master, format: :json)
end
