json.extract! booklist, :id, :user_id, :textbook_id, :serial, :deleted_at, :created_at, :updated_at
json.url booklist_url(booklist, format: :json)