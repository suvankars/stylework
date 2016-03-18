class Product < ActiveRecord::Base
  serialize :images
  # Add dependencies for products
  #require_dependency provides a way to load a file using the current 
  #loading mechanism, and keeping track of constants defined in that file
  # as if they were autoloaded to have them reloaded as needed.
  
  require_dependency 'product/variants'

  belongs_to :subcategory
  serialize :properties, Hash
  has_many :fields, class_name: "ProductField"
  accepts_nested_attributes_for :fields, allow_destroy: true
  belongs_to :supplier
  belongs_to :brand
  belongs_to :tax_rate
  belongs_to :size
  has_many :stock_level

  belongs_to :user
  
  #Mount image uploader 
  mount_uploaders :images, ImageUploader
  has_many :images, as: :parent, dependent: :destroy, autosave: true
  def is_a_variant?
      self.parent_id.nil?
  end

  def in_stock?
    self.quantity > 0
  end

  def stock
    self.quantity + self.stock_level.sum(:adjustment)
  end

end
