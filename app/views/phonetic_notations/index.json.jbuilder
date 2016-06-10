json.array!(@phonetic_notations) do |phonetic_notation|
  json.extract! phonetic_notation, :id, :phonetic_id, :word_id, :deleted_at
  json.url phonetic_notation_url(phonetic_notation, format: :json)
end
