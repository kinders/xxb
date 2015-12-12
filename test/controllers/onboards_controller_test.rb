require 'test_helper'

class OnboardsControllerTest < ActionController::TestCase
  setup do
    @onboard = onboards(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:onboards)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create onboard" do
    assert_difference('Onboard.count') do
      post :create, onboard: { begin_at: @onboard.begin_at, deleted_at: @onboard.deleted_at, end_at: @onboard.end_at, expire_at: @onboard.expire_at, http_user_agent: @onboard.http_user_agent, remote_ip: @onboard.remote_ip, user_id: @onboard.user_id }
    end

    assert_redirected_to onboard_path(assigns(:onboard))
  end

  test "should show onboard" do
    get :show, id: @onboard
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @onboard
    assert_response :success
  end

  test "should update onboard" do
    patch :update, id: @onboard, onboard: { begin_at: @onboard.begin_at, deleted_at: @onboard.deleted_at, end_at: @onboard.end_at, expire_at: @onboard.expire_at, http_user_agent: @onboard.http_user_agent, remote_ip: @onboard.remote_ip, user_id: @onboard.user_id }
    assert_redirected_to onboard_path(assigns(:onboard))
  end

  test "should destroy onboard" do
    assert_difference('Onboard.count', -1) do
      delete :destroy, id: @onboard
    end

    assert_redirected_to onboards_path
  end
end
