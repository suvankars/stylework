class Product < ActiveRecord::Base
  has_many :variants, :class_name => "Product", :foreign_key => "parent_id", dependent: :destroy
  belongs_to :parent, :class_name => "Product"

  #If Product has variants then update the parent product pricing info
  # also update variant with parent product field
  
  before_save do 
    if self.parent
      self.tax_rate = self.parent.tax_rate
      self.supplier_id = self.parent.supplier_id
      self.brand_id = self.parent.brand_id
      self.description = self.parent.description
      self.short_description = self.parent.short_description
    end
  end
      
      
  after_save do
    if self.parent
      self.parent.price = 0
      self.parent.cost_price = 0
      self.parent.quantity = 0
      self.parent.size_id  = nil
     
      self.parent.save if self.parent.changed?
    end
  end

  def has_variants?
      !variants.empty?
  end

 
  
end