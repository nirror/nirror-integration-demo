json.array!(@visits) do |visit|
  json.extract! visit, :id, :nirror_hash_path
  json.url visit_url(visit, format: :json)
end
