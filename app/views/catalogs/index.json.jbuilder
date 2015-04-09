json.array!(@catalogs) do |catalog|
  json.extract! catalog, :id, :serial, :user_id, :textbook_id, :lesson_id
  json.url catalog_url(catalog, format: :json)
end
