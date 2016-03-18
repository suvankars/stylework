class VariantsController < ApplicationController
  before_action :set_variant, only: [:show, :edit, :update]
  
  def index
    @product = Product.find(params[:product_id])
    @variants = @product.variants.all
  end
  
  def new
    @product = Product.find(params[:product_id])
    @variant = @product.variants.new
    @tax_rates = TaxRate.all.map{|tr| [tr.tax_description, tr.id]}
    @default_tax_rate = [@product.tax_rate.tax_description, @product.tax_rate.id]

    @sizes = Size.all.map{|s| [s.description, s.id]}
    @default_size = @sizes.first
  end

  def create
    @product = Product.find(params[:product_id])
    @variant = @product.variants.new(variants_params)
    
    if @variant.save
      redirect_to [@product, :variants], notice: 'Variant was successfully created.'
    else
      render :new 
    end
  end

  def edit
    @product = Product.find(params[:product_id])
    @variant = @product.variants.find(params[:id])
    render :partial => "form"
  end

  def update
    if @variant.update(variants_params)
      redirect_to edit_product_variant_path(@product, @variant), :notice => t('variants.update_notice')
    else
      render :action => "form"
    end
  end

  def destroy
      @product = Product.find(params[:product_id])
      @product.variants.find(params[:id]).destroy
      redirect_to products_path, :notice =>  t('variants.destroy_notice')
    end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_variant
      @product = Product.find(params[:product_id])
      @variant = @product.variants.new
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def variants_params
      params.require(:product).permit(:name, :permalink, :skuid, :price, :cost_price, :tax_rate_id, :size_id, :quantity, :product_id)
    end

end