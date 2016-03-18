class Api::V1::ProductsController < Api::V1::BaseController
  after_filter :cors_set_access_control_headers

def cors_set_access_control_headers
  headers['Access-Control-Allow-Origin'] = '*'
  headers['Access-Control-Allow-Methods'] = 'POST, GET, PUT, DELETE, OPTIONS'
  headers['Access-Control-Allow-Headers'] = 'Origin, Content-Type, Accept, Authorization, Token'
  
end
  api :GET, 'api/v1/products', "Get All Products"
  description "Get all Product(s)/ Variant(s) present in the inventory"
  formats ['json']
  example "[
    {
      'id': 2,
      'name': 'Choko Lava',
      'skuid': 'CHKL',
      'short_description': 'a short description for our product',
      'active': true,
      'quantity': 0,
      'price': '0.0',
      'created_at': '2016-01-16 16:51:41 UTC',
      'updated_at': '2016-01-16 18:53:31 UTC'
    },
    {
      'id': 5,
      'name': 'Black forest',
      'skuid': 'asxd',
      'short_description': 'a short description for our product',
      'active': true,
      'quantity': 14,
      'price': '212.0',
      'created_at': '2016-01-16 18:55:31 UTC',
      'updated_at': '2016-01-16 18:55:31 UTC'
    },
    {
      'id': 7,
      'name': 'Mamba',
      'skuid': 'MBM',
      'short_description': 'something',
      'active': true,
      'quantity': 56,
      'price': '456.0',
      'created_at': '2016-01-16 20:14:02 UTC',
      'updated_at': '2016-01-16 20:14:02 UTC'
    }
  ]"
  def index
    products = Product.all
    @variants = []
    
    products.each do |product|
      if product.has_variants?
        product.variants.all.each { |variant| @variants << variant }
      elsif product.is_a_variant?
        @variants << product
      end
    end
    @variants
  end

  api :GET, 'api/v1/products/id', "Get details of a Product"
  description "Get details of a Product"
  formats ['json']
    example "{
    'id': 2,
    'name': 'Kulfi Malai',
    'skuid': 'klfm',
    'short_description': 'for mobile',
    'quantity': 7,
    'price': '78.0',
    'parent_id': null,
    'subcategory_id': 1
  }"
  def show
    #TO ugly clean up 
    product = Product.find(params[:id])
    if !product.is_a_variant?
      @variant = product
    elsif !product.has_variants?
      @variant = product
    end
    @variant
  end
end