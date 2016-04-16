class Frontend::SchedulesController < FrontendController
  # Actually monkey-patch String 
  String.include CoreExtensions::String
   
  before_action :set_schedule, only: [:show, :edit, :update, :destroy]
  before_action :set_list, only: [:create, :new, :show, :edit, :destroy]
  
  def index
    @schedules = Schedule.all
  end


  def show
     @schedule = Schedule.last
  end


  def new
    respond_to do |format|
       format.js {render "new", locals: {mah_list: @list} }
    end
  end


  def edit
    respond_to do |format|
       format.js {render "edit", locals: {list: @list, schedule: @schedule} }
    end
  end

  def create_slot(slot_time)
   
    schedule = @list.schedule.new(schedule_params)
    
    slot_time == :morning ? schedule.set_morning_slot  : schedule.set_evening_slot

    schedule.save
  end

  def create
    #TODO Clean it
    @schedule = @list.schedule.new(schedule_params)
    morning_ride  = params[:schedule][:morning_ride]
    evening_ride = params[:schedule][:evening_ride]

    if (  morning_ride.to_bool and evening_ride.to_bool )
      if ( create_slot(:morning) and create_slot(:evening) )
        render nothing: true
      else
      end
    else
      @schedule.set_morning_slot if params[:schedule][:morning_ride].to_bool 
      @schedule.set_evening_slot if params[:schedule][:evening_ride].to_bool
      
      if @schedule.save
        render nothing: true
      else
        render text: @schedule.errors.full_messages.to_sentence, status: 422
      end
    end
  end


  def update
    

    respond_to do |format|
      if @schedule.update(schedule_params.except(:start_time, :end_time))
        @schedule.set_morning_slot if params[:schedule][:morning_ride].to_bool 
        @schedule.set_evening_slot if params[:schedule][:evening_ride].to_bool

        #format.html { redirect_to @schedule, notice: 'Schedule was successfully updated.' }
        #format.json { render :show, status: :ok, location: @schedule }
        format.js { render nothing: true}
      else
        #format.html { render :edit }
        #format.json { render json: @schedule.errors, status: :unprocessable_entity }
        format.js {render text: @schedule.errors.full_messages.to_sentence, status: 422}
      end
    end
  end


  def destroy
    @schedule.destroy
    respond_to do |format|
      format.html { redirect_to list_path(@list), notice: 'Schedule was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_schedule
      @schedule = Schedule.find(params[:id])
    end

    def set_list
      @list = List.find(params[:list_id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def schedule_params
      params.require(:schedule).permit(:start_time, :end_time, :morning_ride, :evening_ride, :all_day)
    end
end
