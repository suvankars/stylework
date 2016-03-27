class Backend::ProductsController < BackendController
  before_filter :authenticate_user!
  load_and_authorize_resource
  before_action :set_product, only: [:show, :edit,  :destroy]
  attr_accessor :parked_images


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

  def get_image_id
     if product_params[:image_id].present?
      preloaded = Cloudinary::PreloadedFile.new(product_params[:image_id])
      # Verify signature by calling preloaded.valid?
      return preloaded.identifier
    end
  end

  
  #POST /products/park_images
  
  def park_images
    #Rails casche provides a way to pass temporary objects between controller actions. 
    
    if request.xhr?
      Rails.cache.write("images", populate_images)
      render nothing: true
    else
      #Do something!
      #DO not Assumed that everything will fine forever
    end
  end

  # POST /products
  # POST /products.json

  def create
    respond_to do |format|
      @product = Product.new(product_params)
      @product.user = current_user
      #@product.image_id = get_image_id
      @product.cloudinary_images = Rails.cache.read("images")  
      
      #Clear cache once it is used 
      Rails.cache.delete('images')
      
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

  def previous_images
    # Incase of park_images action; no product object is initialized; till then return an empty []   
    if !@product.nil? 
      images = @product.cloudinary_images # copy the old images 
    else
      images = []  
    end
  end

  def populate_images
    images = previous_images
    
    if params[:data_value].present?
      data_values = params[:data_value]
      data_values.each do |index, image_metadata|
        metadata = image_metadata.permit(:public_id, :version, :signature, :width, :height, :format, :resource_type, :created_at, :bytes, :type, :etag, :url, :secure_url, :original_filename, :delete_token, :path, :thumbnail_url)
        images << metadata.to_h
      end
    end
    images
  end


  def save_images
    if @product.update_column :cloudinary_images, populate_images   
        render nothing: true
    else
      render js: "alert('There is some issue to store images')"
    end
  end
  
  def update
    if request.xhr?
      respond_to do |format|
        if @product.update_column :cloudinary_images, populate_images   
          #render nothing: true
          format.js   {}
        else
          render js: "alert('There is some issue to store images')"
        end
    end
    #save_images
  
   else 
     respond_to do |format|
          #set_product if @product.nil?
      
          if @product.update(product_params.except(:images))
            # new_images = product_params[:images]
            # images = @product.images # copy the old images 
            # images += new_images if !new_images.nil? # concat old images with new ones
            #@product.images = images
            #@product.image_id = image_id
            @product.save
            format.html { redirect_to @product, notice: 'Product was successfully updated.' }
            format.json { render :show, status: :ok, location: @product }
          else
            format.html { render :edit }
            format.json { render json: @product.errors, status: :unprocessable_entity }
          end
      end
    end
  end

  # DELETE /products/1
  # DELETE /products/1.json
  def destroy
    @product.cloudinary_images.each do |image|
      Cloudinary::Uploader.destroy(image["public_id"])
    end

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
                                      
                                      :remove_images,
                                      :image_id,
                                      #:images => {:extra => file_params },
                                       properties: params[:product][:properties].try(:keys))

     
    end

   
end
