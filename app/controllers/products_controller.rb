class ProductsController < ApplicationController
  before_filter :authenticate_user!
  load_and_authorize_resource
  before_action :set_product, only: [:show, :edit, :update, :destroy]



def cors_set_access_control_headers
    headers['Access-Control-Allow-Origin'] = '*'
    headers['Access-Control-Allow-Methods'] = 'POST, GET, PUT, DELETE, OPTIONS'
    headers['Access-Control-Allow-Headers'] = 'Origin, Content-Type, Accept, Authorization, Token'
    headers['Access-Control-Max-Age'] = "1728000"
end

  # GET /products
  # GET /products.json
  def index
    if current_user.admin?
      @products = Product.all
    else
      @products = current_user.products.all
    end
    
    @cat = Category.all
    @categories = Category.all
  end

  # GET /products/1
  # GET /products/1.json
  def show
  end

  # GET /products/new
  def new
    #TODO Refactor, Nasty code
    @product = Product.new(subcategory_id: params[:subcategory_id])
    @subcategory_names = Subcategory.all.map{|sub| [sub.name, sub.id] }
    @supplier_names = Supplier.all.map{|sup| [sup.company, sup.id]}
    @brand_names = Brand.all.map{|br| [br.name, br.id]}
    @default_brand = @brand_names.first
    @default_subcategory = @subcategory_names.first
    @default_supplier  = @subcategory_names.first
    @tax_rates = TaxRate.all.map{|tr| [tr.tax_description, tr.id]}
    @default_tax_rate = @tax_rates.first

    @sizes = Size.all.map{|s| [s.description, s.id]}
    @default_size = @sizes.first
  end

  # GET /products/1/edit
  def edit
    @product = Product.find(params[:id])
    @subcategory_names = Subcategory.all.map{|sub| [sub.name, sub.id] }
    @supplier_names = Supplier.all.map{|sup| [sup.company, sup.id]}
    @brand_names = Brand.all.map{|br| [br.name, br.id]}
    @default_brand =  [@product.brand.name, @product.brand.id ]
    @default_subcategory = [@product.subcategory.name, @product.subcategory.id]
    @default_supplier = [@product.supplier.company, @product.supplier.id]
    @tax_rates = TaxRate.all.map{|tr| [tr.tax_description, tr.id]}
    @default_tax_rate = [@product.tax_rate.tax_description, @product.tax_rate.id]
  end

  # POST /products
  # POST /products.json
  def create
    @product = Product.new(product_params)
    
    @product.user = current_user

    respond_to do |format|
      if @product.save
        format.html { redirect_to @product, notice: 'Product was successfully created.' }
        format.json { render :show, status: :created, location: @product }
      else
        format.html { render :new }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /products/1
  # PATCH/PUT /products/1.json
  def update
    respond_to do |format|
      if @product.update(product_params.except(:images))
        new_images = product_params[:images]
        images = @product.images # copy the old images 
        images += new_images if !new_images.nil? # concat old images with new ones
        @product.images = images
        @product.save
        format.html { redirect_to @product, notice: 'Product was successfully updated.' }
        format.json { render :show, status: :ok, location: @product }
      else
        format.html { render :edit }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /products/1
  # DELETE /products/1.json
  def destroy
    @product.destroy
    respond_to do |format|
      format.html { redirect_to products_url, notice: 'Product was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_product
      @product = Product.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def product_params
      file_params = [:file, :parent_id, :role, :parent_type, :file => []]
      params.require(:product).permit(:name, :skuid, :brand_id, :tax_rate_id, 
                                      :subcategory_id, :supplier_id, 
                                      :permalink, :description, :short_description, 
                                      :price, :cost_price, :size_id, :quantity,
                                      {images: []},
                                      :remove_images,
                                      #:images => {:extra => file_params },
                                       properties: params[:product][:properties].try(:keys))
    end
end
