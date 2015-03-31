json.array!(@tutors) do |tutor|
  json.extract! tutor, :id, :title, :difficulty, :page, :user_id
  json.url tutor_url(tutor, format: :json)
end
