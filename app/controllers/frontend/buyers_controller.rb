class Frontend::BuyersController < FrontendController

  def index
    @items = Product.all
  end

  def show
    @item = Product.find(params[:id])
  end

end
