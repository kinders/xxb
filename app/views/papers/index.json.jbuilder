json.array!(@papers) do |paper|
  json.extract! paper, :id, :user_id, :title, :duration, :deleted_at
  json.url paper_url(paper, format: :json)
end
