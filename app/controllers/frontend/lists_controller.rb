class Frontend::ListsController < FrontendController
  before_action :set_list, only: [:show, :edit, :update, :destroy]


  def index
    if params[:search].present?
      @lists = List.near(params[:search], 5)
    else
      @lists = List.all
    end

    @hash = Gmaps4rails.build_markers(@lists) do |list, marker|
      marker.lat list.latitude
      marker.lng list.longitude
      marker.json({:id => list.id })
    end
    
    if request.xhr?
      respond_to do |format|
        format.json { render :json => @hash }
      end
    end
  end


  def show

  end


  def new
    @list = List.new
  end


  def edit
  end


  def create
    @list = List.new(list_params)
    @list.images = Rails.cache.read("images")
    Rails.cache.delete('images')  
    respond_to do |format|
      if @list.save
        format.html { redirect_to @list, notice: 'List was successfully created.' }
        format.json { render :show, status: :created, location: @list }
      else
        format.html { render :new }
        format.json { render json: @list.errors, status: :unprocessable_entity }
      end
    end
  end


  def update
    parked_images = Rails.cache.read("images")
    Rails.cache.delete('images')

    @list.update_column :images , parked_images
    
    respond_to do |format|
      if @list.update(list_params)
        format.html { redirect_to @list, notice: 'List was successfully updated.' }
        format.json { render :show, status: :ok, location: @list }
      else
        format.html { render :edit }
        format.json { render json: @list.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @list.destroy
    respond_to do |format|
      format.html { redirect_to frontend_lists_url, notice: 'List was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_list
      @list = List.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def list_params
      params.require(:list).permit(:ride_title, :ride_description, :rider_height, :frame_size, :hourly_rental, :daily_rental, :weekly_rental, :willing_to_deliver, :address, :city, :state, :pincode, :landmark)
    end
end
