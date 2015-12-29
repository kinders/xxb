json.array!(@paperitems) do |paperitem|
  json.extract! paperitem, :id, :user_id, :paper_id, :practice_id, :score, :deleted_at
  json.url paperitem_url(paperitem, format: :json)
end
