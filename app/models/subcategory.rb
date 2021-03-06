class Subcategory < ActiveRecord::Base
  belongs_to :category

  has_many :fields, class_name: "ProductField", dependent: :destroy
  accepts_nested_attributes_for :fields, allow_destroy: true 
  validates :name, :description, presence: true
  has_many :products, dependent: :destroy
  has_many :rides
  def has_products?
    !self.products.empty?
  end

  #To filter
  def self.options_for_select
    order('LOWER(name)').map { |e| [e.name, e.id] }
  end
end
