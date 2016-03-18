class Supplier < ActiveRecord::Base
  has_one :contact, inverse_of: :supplier
  has_many :address, inverse_of: :supplier
  has_one :finance, inverse_of: :supplier
  has_many :products, inverse_of: :supplier
end
