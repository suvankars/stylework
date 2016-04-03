class List < ActiveRecord::Base
  p "List can have one product category,subcatrgory "
  #but as list is not a product it does't belongs to product 
  #has_one :category
  #has_one :subcategory
end
