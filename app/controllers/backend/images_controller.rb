class Backend::ImagesController < BackendController
  before_action :set_gallery

  def create
    add_more_images(images_params[:images])
    flash[:error] = "Failed uploading images" unless @product.save
    redirect_to :back
  end

  def destroy
    #binding.pry
    remove_by_pub_id(params[:id])
    flash[:error] = "Failed deleting image" unless @product.save
    redirect_to :back
  end

  def remove_all
    #TODO find a way to delete elements from fields 
    @product.cloudinary_images = [] #Just assiging blank; to get work done as of now
    @product.save
    redirect_to :back
  end

  private

  def set_gallery
    @product = Product.find(params[:product_id])
  end

  def add_more_images(new_images)
    images = @product.images # copy the old images 
    images += new_images # concat old images with new ones
    @product.images = images # assign back
  end

  def remove_by_pub_id(public_id)
    #binding.pry
    remain_images = @product.cloudinary_images # copy the array
    deleted_image = @product.cloudinary_images.delete_if { |i| i["public_id"] == public_id } # delete the target image
    Cloudinary::Uploader.destroy(public_id, options = {})
    @product.cloudinary_images = remain_images # re-assign back
  end

  def remove_image_at_index(index)
    remain_images = @product.images # copy the array
    deleted_image = remain_images.delete_at(index) # delete the target image
    deleted_image.try(:remove!) # delete image from S3
    @product.images = remain_images # re-assign back
  end

  def images_params
    params.require(:product).permit({images: []}) # allow nested params as array
  end
  

end
