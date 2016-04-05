class List < ActiveRecord::Base
  #List can have one product category and a subcatrgory "
  #but as list is not a product it does't belongs to product 
  has_one :category
  has_one :subcategory

  geocoded_by :address   
  # auto-fetch coordinates
  after_validation :geocode
   
end

