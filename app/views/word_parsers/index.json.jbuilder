json.array!(@word_parsers) do |word_parser|
  json.extract! word_parser, :id, :word_id, :lesson_id, :deleted_at
  json.url word_parser_url(word_parser, format: :json)
end
