require 'test_helper'

class Frontend::ListsControllerTest < ActionController::TestCase
  setup do
    @frontend_list = frontend_lists(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:frontend_lists)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create frontend_list" do
    assert_difference('Frontend::List.count') do
      post :create, frontend_list: { address: @frontend_list.address, city: @frontend_list.city, daily_rental: @frontend_list.daily_rental, frame_size: @frontend_list.frame_size, hourly_rental: @frontend_list.hourly_rental, landmark: @frontend_list.landmark, pincode: @frontend_list.pincode, ride_description: @frontend_list.ride_description, ride_title: @frontend_list.ride_title, rider_height: @frontend_list.rider_height, state: @frontend_list.state, weekly_rental: @frontend_list.weekly_rental, willing_to_deliver: @frontend_list.willing_to_deliver }
    end

    assert_redirected_to frontend_list_path(assigns(:frontend_list))
  end

  test "should show frontend_list" do
    get :show, id: @frontend_list
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @frontend_list
    assert_response :success
  end

  test "should update frontend_list" do
    patch :update, id: @frontend_list, frontend_list: { address: @frontend_list.address, city: @frontend_list.city, daily_rental: @frontend_list.daily_rental, frame_size: @frontend_list.frame_size, hourly_rental: @frontend_list.hourly_rental, landmark: @frontend_list.landmark, pincode: @frontend_list.pincode, ride_description: @frontend_list.ride_description, ride_title: @frontend_list.ride_title, rider_height: @frontend_list.rider_height, state: @frontend_list.state, weekly_rental: @frontend_list.weekly_rental, willing_to_deliver: @frontend_list.willing_to_deliver }
    assert_redirected_to frontend_list_path(assigns(:frontend_list))
  end

  test "should destroy frontend_list" do
    assert_difference('Frontend::List.count', -1) do
      delete :destroy, id: @frontend_list
    end

    assert_redirected_to frontend_lists_path
  end
end
