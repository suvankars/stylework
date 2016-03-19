json.array!(@suppliers) do |supplier|
  json.extract! supplier, :id, :company, :code, :status, :description
  json.url supplier_url(supplier, format: :json)
end
