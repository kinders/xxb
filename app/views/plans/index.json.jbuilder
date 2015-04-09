json.array!(@plans) do |plan|
  json.extract! plan, :id, :serail, :user_id, :teaching_id, :tutor_id
  json.url plan_url(plan, format: :json)
end
