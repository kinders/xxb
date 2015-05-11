json.array!(@classrooms) do |classroom|
  json.extract! classroom, :id, :name, :user_id, :end
  json.url classroom_url(classroom, format: :json)
end
