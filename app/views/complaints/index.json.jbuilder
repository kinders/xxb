json.array!(@complaints) do |complaint|
  json.extract! complaint, :id, :user_id, :url, :content, :deleted_at
  json.url complaint_url(complaint, format: :json)
end
