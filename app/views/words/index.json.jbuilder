json.array!(@words) do |word|
  json.extract! word, :id, :name, :length, :deleted_at
  json.url word_url(word, format: :json)
end
