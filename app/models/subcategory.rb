class Subcategory < ActiveRecord::Base
  belongs_to :category
  has_many :fields, class_name: "ProductField"
  accepts_nested_attributes_for :fields, allow_destroy: true 
  validates :name, :description, presence: true
  has_many :products, dependent: :destroy

  def has_products?
    !self.products.empty?
  end
end
