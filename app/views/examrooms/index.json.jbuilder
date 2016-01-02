json.array!(@examrooms) do |examroom|
  json.extract! examroom, :id, :user_id, :classroom_id, :paper_id, :deleted_at, :isactive
  json.url examroom_url(examroom, format: :json)
end
