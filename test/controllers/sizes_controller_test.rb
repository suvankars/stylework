require '/home/suvankar/dream/bicycleyard/test/test_helper'

class SizesControllerTest < ActionController::TestCase
  setup do
    @size = sizes(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:sizes)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create size" do
    assert_difference('Size.count') do
      post :create, size: { name: @size.name, unit: @size.unit, volume: @size.volume }
    end

    assert_redirected_to size_path(assigns(:size))
  end

  test "should show size" do
    get :show, id: @size
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @size
    assert_response :success
  end

  test "should update size" do
    patch :update, id: @size, size: { name: @size.name, unit: @size.unit, volume: @size.volume }
    assert_redirected_to size_path(assigns(:size))
  end

  test "should destroy size" do
    assert_difference('Size.count', -1) do
      delete :destroy, id: @size
    end

    assert_redirected_to sizes_path
  end
end
