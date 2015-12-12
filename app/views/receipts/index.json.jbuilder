json.array!(@receipts) do |receipt|
  json.extract! receipt, :id, :user_id, :active_time_before_charge, :money, :time_length, :active_time_after_charge, :cashier, :deleted_at
  json.url receipt_url(receipt, format: :json)
end
