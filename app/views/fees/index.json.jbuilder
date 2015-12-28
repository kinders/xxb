json.array!(@fees) do |fee|
  json.extract! fee, :id, :user_id, :name, :price, :serial, :end_at, :deleted_at
  json.url fee_url(fee, format: :json)
end
