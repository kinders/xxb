json.array!(@cashiers) do |cashier|
  json.extract! cashier, :id, :user_id, :deleted_at
  json.url cashier_url(cashier, format: :json)
end
