require 'test_helper'

class WordmapsControllerTest < ActionController::TestCase
  setup do
    @wordmap = wordmaps(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:wordmaps)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create wordmap" do
    assert_difference('Wordmap.count') do
      post :create, wordmap: { deleted_at: @wordmap.deleted_at, name: @wordmap.name, roadmap_id: @wordmap.roadmap_id, user_id: @wordmap.user_id }
    end

    assert_redirected_to wordmap_path(assigns(:wordmap))
  end

  test "should show wordmap" do
    get :show, id: @wordmap
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @wordmap
    assert_response :success
  end

  test "should update wordmap" do
    patch :update, id: @wordmap, wordmap: { deleted_at: @wordmap.deleted_at, name: @wordmap.name, roadmap_id: @wordmap.roadmap_id, user_id: @wordmap.user_id }
    assert_redirected_to wordmap_path(assigns(:wordmap))
  end

  test "should destroy wordmap" do
    assert_difference('Wordmap.count', -1) do
      delete :destroy, id: @wordmap
    end

    assert_redirected_to wordmaps_path
  end
end
