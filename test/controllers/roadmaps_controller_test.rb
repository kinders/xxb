require 'test_helper'

class RoadmapsControllerTest < ActionController::TestCase
  setup do
    @roadmap = roadmaps(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:roadmaps)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create roadmap" do
    assert_difference('Roadmap.count') do
      post :create, roadmap: { deleted_at: @roadmap.deleted_at, description: @roadmap.description, name: @roadmap.name, user_id: @roadmap.user_id }
    end

    assert_redirected_to roadmap_path(assigns(:roadmap))
  end

  test "should show roadmap" do
    get :show, id: @roadmap
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @roadmap
    assert_response :success
  end

  test "should update roadmap" do
    patch :update, id: @roadmap, roadmap: { deleted_at: @roadmap.deleted_at, description: @roadmap.description, name: @roadmap.name, user_id: @roadmap.user_id }
    assert_redirected_to roadmap_path(assigns(:roadmap))
  end

  test "should destroy roadmap" do
    assert_difference('Roadmap.count', -1) do
      delete :destroy, id: @roadmap
    end

    assert_redirected_to roadmaps_path
  end
end
