json.array!(@subjects) do |subject|
  json.extract! subject, :id, :name, :deleted_at
  json.url subject_url(subject, format: :json)
end
