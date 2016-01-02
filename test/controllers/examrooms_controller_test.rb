require 'test_helper'

class ExamroomsControllerTest < ActionController::TestCase
  setup do
    @examroom = examrooms(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:examrooms)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create examroom" do
    assert_difference('Examroom.count') do
      post :create, examroom: { classroom_id: @examroom.classroom_id, deleted_at: @examroom.deleted_at, isactive: @examroom.isactive, paper_id: @examroom.paper_id, user_id: @examroom.user_id }
    end

    assert_redirected_to examroom_path(assigns(:examroom))
  end

  test "should show examroom" do
    get :show, id: @examroom
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @examroom
    assert_response :success
  end

  test "should update examroom" do
    patch :update, id: @examroom, examroom: { classroom_id: @examroom.classroom_id, deleted_at: @examroom.deleted_at, isactive: @examroom.isactive, paper_id: @examroom.paper_id, user_id: @examroom.user_id }
    assert_redirected_to examroom_path(assigns(:examroom))
  end

  test "should destroy examroom" do
    assert_difference('Examroom.count', -1) do
      delete :destroy, id: @examroom
    end

    assert_redirected_to examrooms_path
  end
end
