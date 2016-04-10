class Frontend::SellersController < FrontendController

  def new
    @sell_product = Product.new
  end

   def create
    @sell_product = Product.new(seller_params)
    @sell_product.cloudinary_images = Rails.cache.read("images")
    Rails.cache.delete('images')
    respond_to do |format|
      if @sell_product.valid?
        @sell_product.save!
        format.html { redirect_to @sell_product, notice: 'Sell Post is successfully created.' }
      end
    end
   end


  private

  def seller_params
    params.require(:product).permit(:name, :location, :price, :model_title,
                                         :model_size, :cost_price, :phone_number,
                                         :reason, :description, :short_description, :purchase_year,
                                         :brand_name)
  end
end
