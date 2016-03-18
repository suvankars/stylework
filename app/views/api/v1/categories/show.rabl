collection @subcategory

attributes :id, :name, :description
child(@variants) {attributes :id, :name, :skuid, :short_description, :active, :quantity, :price, :created_at, :updated_at}