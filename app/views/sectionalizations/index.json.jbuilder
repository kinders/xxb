json.array!(@sectionalizations) do |sectionalization|
  json.extract! sectionalization, :id, :user_id, :classroom_id, :name, :deleted_at
  json.url sectionalization_url(sectionalization, format: :json)
end
