json.array!(@cards) do |card|
  json.extract! card, :id, :user_id, :practice_id, :cardbox_id, :serial, :degree, :nexttime, :foul, :count, :deleted_at
  json.url card_url(card, format: :json)
end
