json.array!(@discussions) do |discussion|
  json.extract! discussion, :id, :user_id, :classroom_id, :lesson_id, :teaching_id, :end, :deleted_at
  json.url discussion_url(discussion, format: :json)
end
