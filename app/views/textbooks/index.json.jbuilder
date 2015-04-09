json.array!(@textbooks) do |textbook|
  json.extract! textbook, :id, :title, :description, :serial, :user_id
  json.url textbook_url(textbook, format: :json)
end
