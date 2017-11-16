require 'test_helper'

class WordordersControllerTest < ActionController::TestCase
  setup do
    @wordorder = wordorders(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:wordorders)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create wordorder" do
    assert_difference('Wordorder.count') do
      post :create, wordorder: { deleted_at: @wordorder.deleted_at, serial: @wordorder.serial, user_id: @wordorder.user_id, word_id: @wordorder.word_id, wordmap_id: @wordorder.wordmap_id }
    end

    assert_redirected_to wordorder_path(assigns(:wordorder))
  end

  test "should show wordorder" do
    get :show, id: @wordorder
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @wordorder
    assert_response :success
  end

  test "should update wordorder" do
    patch :update, id: @wordorder, wordorder: { deleted_at: @wordorder.deleted_at, serial: @wordorder.serial, user_id: @wordorder.user_id, word_id: @wordorder.word_id, wordmap_id: @wordorder.wordmap_id }
    assert_redirected_to wordorder_path(assigns(:wordorder))
  end

  test "should destroy wordorder" do
    assert_difference('Wordorder.count', -1) do
      delete :destroy, id: @wordorder
    end

    assert_redirected_to wordorders_path
  end
end
