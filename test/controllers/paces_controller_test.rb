require 'test_helper'

class PacesControllerTest < ActionController::TestCase
  setup do
    @pace = paces(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:paces)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create pace" do
    assert_difference('Pace.count') do
      post :create, pace: { deleted_at: @pace.deleted_at, lesson_id: @pace.lesson_id, roadmap_id: @pace.roadmap_id, serial: @pace.serial, user_id: @pace.user_id }
    end

    assert_redirected_to pace_path(assigns(:pace))
  end

  test "should show pace" do
    get :show, id: @pace
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @pace
    assert_response :success
  end

  test "should update pace" do
    patch :update, id: @pace, pace: { deleted_at: @pace.deleted_at, lesson_id: @pace.lesson_id, roadmap_id: @pace.roadmap_id, serial: @pace.serial, user_id: @pace.user_id }
    assert_redirected_to pace_path(assigns(:pace))
  end

  test "should destroy pace" do
    assert_difference('Pace.count', -1) do
      delete :destroy, id: @pace
    end

    assert_redirected_to paces_path
  end
end
