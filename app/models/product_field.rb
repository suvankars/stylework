class ProductField < ActiveRecord::Base
  belongs_to :subcategory
  #attr_accessible :field_type, :name, :required
end
