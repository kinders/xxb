json.extract! wordmap, :id, :user_id, :roadmap_id, :name, :deleted_at, :created_at, :updated_at
json.url wordmap_url(wordmap, format: :json)