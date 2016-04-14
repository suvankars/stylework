class Frontend::SchedulesController < FrontendController
  before_action :set_schedule, only: [:show, :edit, :update, :destroy]
  before_action :set_list, only: [:create, :new, :edit, :destroy]
  def index
    @schedules = Schedule.all
  end


  def show
  end


  def new
    respond_to do |format|
       format.js {render "new", locals: {mah_list: @list} }
    end
  end


  def edit
  end

  def create
    @schedule = @list.schedule.new(schedule_params)
    
    if @schedule.save
      render nothing: true
    else
      render text: @schedule.errors.full_messages.to_sentence, status: 422
    end
  end


  def update
    respond_to do |format|
      if @schedule.update(schedule_params)
        format.html { redirect_to @schedule, notice: 'Schedule was successfully updated.' }
        format.json { render :show, status: :ok, location: @schedule }
      else
        format.html { render :edit }
        format.json { render json: @schedule.errors, status: :unprocessable_entity }
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
