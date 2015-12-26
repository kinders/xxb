json.array!(@quiz_items) do |quiz_item|
  json.extract! quiz_item, :id, :user_id, :quiz_id, :practice_id, :isright, :deleted_at
  json.url quiz_item_url(quiz_item, format: :json)
end
