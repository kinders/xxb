json.array!(@badrecords) do |badrecord|
  json.extract! badrecord, :id, :user_id, :troublemaker, :classroom_id, :troubletime, :subject_id, :description, :finish, :deleted_at
  json.url badrecord_url(badrecord, format: :json)
end
