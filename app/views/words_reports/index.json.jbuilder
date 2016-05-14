json.array!(@words_reports) do |words_report|
  json.extract! words_report, :id, :lesson_id, :md, :deleted_at
  json.url words_report_url(words_report, format: :json)
end
