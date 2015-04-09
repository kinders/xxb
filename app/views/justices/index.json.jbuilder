json.array!(@justices) do |justice|
  json.extract! justice, :id, :score, :remark, :activity, :user_id, :evaluation_id
  json.url justice_url(justice, format: :json)
end
