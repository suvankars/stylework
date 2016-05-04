class Frontend::ListsController < FrontendController
  before_action :set_list, only: [:calendar, :show, :edit, :update, :destroy]
  
  RADIOUS = 15; #mile
  DEFAULT_CATEGORY_NAME = "Bicycle"

  def index
    #binding.pry
    # If search box is clicked without typing any address 
    # There will be value params[:search] = ""
    # If so, delete stored session search value
      
    session[:search] = nil if params[:search] == ""
    
    # If search box is never clicked then
    # params[:search] = nil
    # Then load params from session
    # Situation 1: User came in this page after searching a city
    # then user selecting filter criteria
    # Then ajax request comes here, obviously params[:search] is nil for
    # All ajax request came from filter 
    # So, restore parama value from session
    # Is there any better, simpler way to do it? 

    params[:search] = session[:search] if !params[:search].present?


    #save search params to session for future requests, like filter
    session[:search] = params[:search] if !params[:search].nil?

    lists = List.near(params[:search], RADIOUS)
    
   
    @filterrific = initialize_filterrific(
      lists.empty? ? List.all : lists,
      params[:filterrific],
       select_options: {
        with_subcategory_id: Subcategory.options_for_select,
        with_rider_height: RiderHeight.options_for_select,
        with_frame_size: FrameSize.options_for_select,
        with_morning_rental_lt: List.options_for_select
      },
    ) or return

    if params[:filterrific].present?
      @lists = @filterrific.find.page(params[:page])
    elsif params[:search].present?
      @lists = List.near(params[:search], RADIOUS)
    else
      @lists = List.all
    end

    @hash = Gmaps4rails.build_markers(@lists) do |list, marker|
      marker.lat list.latitude
      marker.lng list.longitude
      marker.json({:id => list.id })
    end
    
    if request.xhr?
      payload = {"lists": JSON::parse(@lists.to_json), "hash": @hash }
      respond_to do |format|
        format.json { render :json => payload}
        format.js 
      end
    end

  end

  

  def get_lists
    #binding.pry
    @lists = List.last#where(created_at: params[:start].to_date..params[:start].to_date)
    events = []
    schedules = @lists.schedules.between(params[:start], params[:end])

    schedules.each do |sch|
      events << sch.format(@lists)
    end

    render json: events
  end

  def availability
  end
  
  def show
    respond_to do |format|
      format.html {  }
      format.js {}
    end
  end


  def new
    #TBD: refactor
    
    @subcategories = default_category.subcategories.map{|sub| [sub.name, sub.id] }
    @default_subcategory = @subcategories.first

    @list = List.new
  end


  def edit
    @subcategories = default_category.subcategories.map{|sub| [sub.name, sub.id] }
    @default_subcategory = [@list.subcategory.name, @list.subcategory_id]
  end

  def calendar
  
  end

  def create
    @list = List.new(list_params)
    @list.images = Rails.cache.read("images")
    Rails.cache.delete('images')
    @list.category_id = default_category.id

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
    
    binding.pry
    old_images = @list.images
    parked_images = Rails.cache.read("images")
    Rails.cache.delete('images')
    parked_images = parked_images.nil? ? old_images : parked_images
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
    #list_id will be used to remove listing from index page
    #TBD remove marker from map. is it required?

    @list_id = @list.id #or params[:id]
    respond_to do |format|
      format.html { redirect_to :back, notice: 'List was successfully destroyed.' }
      format.js {}
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_list
      @list = List.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def list_params
      params.require(:list).permit(:ride_title, :ride_description, :rider_height, :frame_size, :hourly_rental, :daily_rental, :weekly_rental, :willing_to_deliver, :address, :city, :state, :pincode, :landmark, :subcategory_id)
    end

    def default_category
      Category.where( name: DEFAULT_CATEGORY_NAME).first
    end
end
