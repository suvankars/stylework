json.array!(@brands) do |brand|
  json.extract! brand, :id, :name, :short_description, :description, :location
  json.url brand_url(brand, format: :json)
end
