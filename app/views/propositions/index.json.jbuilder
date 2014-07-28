json.array!(@propositions) do |proposition|
  json.extract! proposition, :id, :name
  json.url proposition_url(proposition, format: :json)
end
