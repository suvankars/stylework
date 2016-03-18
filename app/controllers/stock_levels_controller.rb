class StockLevelsController < ApplicationController
  before_action :set_product, only: [:index, :create]

  def index
    @stock_levels = @product.stock_level.all
    @new_stock_level = @product.stock_level.new if @new_stock_level.nil?
  end

  def create
    @stock_level = @product.stock_level.new(params[:stock_level].permit(:description, :adjustment))
    if @stock_level.save
      redirect_to stock_levels_path(:product_id => params[:product_id]), :notice => t('stock_levels.create_notice')
    else
      render :action => "index"
    end
  end

  def destroy
    sl = StockLevel.find(params[:id])
    product_id = sl.product_id
    sl.destroy
    redirect_to stock_levels_path(:product_id => product_id), notice: 'Stock Level was successfully destroyed.' 
  end

  private

  def set_product
    @product = Product.find(params[:product_id])
  end
end