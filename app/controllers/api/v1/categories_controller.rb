class Api::V1::CategoriesController < Api::V1::BaseController
  after_filter :cors_set_access_control_headers

def cors_set_access_control_headers
  headers['Access-Control-Allow-Origin'] = '*'
  headers['Access-Control-Allow-Methods'] = 'POST, GET, PUT, DELETE, OPTIONS'
  headers['Access-Control-Allow-Headers'] = 'Origin, Content-Type, Accept, Authorization, Token'
  
end

  api :GET, "/api/v1/categories", "Get all Categories"
  example " [
  {
    'id': 1,
    'name': 'Ice cream',
    'description': 'A sample description of SubCategory'
  },
  {
    'id': 2,
    'name': 'Cake',
    'description': 'another sub category'
  },
  {
    'id': 3,
    'name': 'Just a test',
    'description': 'a sampl'
  }
  ] "
  formats ['json']

  def index
    @subcategories = Subcategory.all
  end
  


  
  api :GET, '/api/v1/categories/:id', "Get Products by Category"
  description "Get all Product(s)/ Variant(s) of a particular Category"
  formats ['json']
  example "{
  'id': 2,
  'name': 'Cake',
  'description': 'another sub category',
  'products': [
    {
      'product': {
        'id': 6,
        'name': 'Chokoturt',
        'skuid': 'CKSR',
        'short_description': 'something',
        'active': true,
        'quantity': 5,
        'price': '200.0',
        'created_at': '2016-01-16 20:08:37 UTC',
        'updated_at': '2016-01-16 20:08:37 UTC'
      }
    },
    {
      'product': {
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
      }
    ]
  }"
  def show
    @subcategory = Subcategory.find(params[:id])
    products = @subcategory.products.all
    @variants = []
    
    products.each do |product|
      if product.has_variants?
        product.variants.all.each { |variant| @variants << variant }
      else product.has_not_variants?
        @variants << product
      end
    end
    @variants
  end


  

end