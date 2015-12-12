json.array!(@onboards) do |onboard|
  json.extract! onboard, :id, :user_id, :begin_at, :expire_at, :end_at, :remote_ip, :http_user_agent, :deleted_at
  json.url onboard_url(onboard, format: :json)
end
