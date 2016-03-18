class Address < ActiveRecord::Base
  belongs_to :supplier, inverse_of: :address
end
