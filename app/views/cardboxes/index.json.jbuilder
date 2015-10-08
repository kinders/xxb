json.array!(@cardboxes) do |cardbox|
  json.extract! cardbox, :id, :user_id, :name, :deleted_at
  json.url cardbox_url(cardbox, format: :json)
end
