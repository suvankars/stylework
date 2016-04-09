require 'test_helper'

class Frontend::SchedulesControllerTest < ActionController::TestCase
  setup do
    @frontend_schedule = frontend_schedules(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:frontend_schedules)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create frontend_schedule" do
    assert_difference('Frontend::Schedule.count') do
      post :create, frontend_schedule: { all_day: @frontend_schedule.all_day, end_date: @frontend_schedule.end_date, end_time: @frontend_schedule.end_time, evening_ride: @frontend_schedule.evening_ride, morning_ride: @frontend_schedule.morning_ride, start_date: @frontend_schedule.start_date, start_time: @frontend_schedule.start_time }
    end

    assert_redirected_to frontend_schedule_path(assigns(:frontend_schedule))
  end

  test "should show frontend_schedule" do
    get :show, id: @frontend_schedule
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @frontend_schedule
    assert_response :success
  end

  test "should update frontend_schedule" do
    patch :update, id: @frontend_schedule, frontend_schedule: { all_day: @frontend_schedule.all_day, end_date: @frontend_schedule.end_date, end_time: @frontend_schedule.end_time, evening_ride: @frontend_schedule.evening_ride, morning_ride: @frontend_schedule.morning_ride, start_date: @frontend_schedule.start_date, start_time: @frontend_schedule.start_time }
    assert_redirected_to frontend_schedule_path(assigns(:frontend_schedule))
  end

  test "should destroy frontend_schedule" do
    assert_difference('Frontend::Schedule.count', -1) do
      delete :destroy, id: @frontend_schedule
    end

    assert_redirected_to frontend_schedules_path
  end
end
