json.array!(@homeworks) do |homework|
  json.extract! homework, :id, :user_id, :classroom_id, :subject, :title, :description, :deleted_at
  json.url homework_url(homework, format: :json)
end
