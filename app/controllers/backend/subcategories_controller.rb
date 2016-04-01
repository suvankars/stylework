class Backend::SubcategoriesController < BackendController
  before_action :set_subcategory, only: [:show, :destroy]

	def create
		@category = Category.find(params[:category_id])
    p subcategory_params
		@subcategory = @category.subcategories.create(subcategory_params)
		if @subcategory.save
			redirect_to category_path(@category), :flash => { :notice => "Successfully created  subcategory " }
		else
			redirect_to category_path(@category), :flash => { :notice => "Something went wrong" }
		end
	end

  def edit
    @category = Category.find(params[:category_id])
    @subcategory = @category.subcategories.find(params[:id])
  end

  def update
    @category = Category.find(params[:category_id])
    @subcategory = @category.subcategories.find(params[:id])
    if @subcategory.update(subcategory_params)
      redirect_to category_path(@category), :flash => {:notice => "Successfully updated"}
    else
      render 'edit'
    end
  end

  def destroy
    @subcategory.destroy
    respond_to do |format|
      format.html { redirect_to category_path(@category), notice: 'Subcategory was successfully destroyed.' }
    end
  end

  def show
    @products = Product.where(subcategory_id: params[:id] )
  end

	private

  def set_subcategory
    @category = Category.find(params[:category_id])
    @subcategory = @category.subcategories.find(params[:id])
  end

	def subcategory_params
		params.require(:subcategory).permit(:name, :description, fields_attributes: [:id, :field_type, :name])	
	end
end
