json.array!(@phonetics) do |phonetic|
  json.extract! phonetic, :id, :content, :label, :deleted_at
  json.url phonetic_url(phonetic, format: :json)
end
