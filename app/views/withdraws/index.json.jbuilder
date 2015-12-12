json.array!(@withdraws) do |withdraw|
  json.extract! withdraw, :id, :user_id, :money, :memo
  json.url withdraw_url(withdraw, format: :json)
end
