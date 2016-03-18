class TaxRate < ActiveRecord::Base
  has_one :product

  def tax_description
    "#{code} - #{name} (#{rate}%)"
  end
end
