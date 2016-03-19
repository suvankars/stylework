json.array!(@products) do |product|
  json.extract! product, :id, :name, :skuid, :brand
  json.url product_url(product, format: :json)
end
