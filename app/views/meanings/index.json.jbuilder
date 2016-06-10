json.array!(@meanings) do |meaning|
  json.extract! meaning, :id, :content, :word_id, :deleted_at
  json.url meaning_url(meaning, format: :json)
end
