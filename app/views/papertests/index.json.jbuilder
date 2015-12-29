json.array!(@papertests) do |papertest|
  json.extract! papertest, :id, :user_id, :paper_id, :end_at, :deleted_at
  json.url papertest_url(papertest, format: :json)
end
