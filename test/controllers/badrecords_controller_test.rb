require 'test_helper'

class BadrecordsControllerTest < ActionController::TestCase
  setup do
    @badrecord = badrecords(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:badrecords)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create badrecord" do
    assert_difference('Badrecord.count') do
      post :create, badrecord: { classroom_id: @badrecord.classroom_id, deleted_at: @badrecord.deleted_at, description: @badrecord.description, finish: @badrecord.finish, subject_id: @badrecord.subject_id, troublemaker: @badrecord.troublemaker, troubletime: @badrecord.troubletime, user_id: @badrecord.user_id }
    end

    assert_redirected_to badrecord_path(assigns(:badrecord))
  end

  test "should show badrecord" do
    get :show, id: @badrecord
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @badrecord
    assert_response :success
  end

  test "should update badrecord" do
    patch :update, id: @badrecord, badrecord: { classroom_id: @badrecord.classroom_id, deleted_at: @badrecord.deleted_at, description: @badrecord.description, finish: @badrecord.finish, subject_id: @badrecord.subject_id, troublemaker: @badrecord.troublemaker, troubletime: @badrecord.troubletime, user_id: @badrecord.user_id }
    assert_redirected_to badrecord_path(assigns(:badrecord))
  end

  test "should destroy badrecord" do
    assert_difference('Badrecord.count', -1) do
      delete :destroy, id: @badrecord
    end

    assert_redirected_to badrecords_path
  end
end
