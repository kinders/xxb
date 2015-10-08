require 'test_helper'

class CardboxesControllerTest < ActionController::TestCase
  setup do
    @cardbox = cardboxes(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:cardboxes)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create cardbox" do
    assert_difference('Cardbox.count') do
      post :create, cardbox: { deleted_at: @cardbox.deleted_at, name: @cardbox.name, user_id: @cardbox.user_id }
    end

    assert_redirected_to cardbox_path(assigns(:cardbox))
  end

  test "should show cardbox" do
    get :show, id: @cardbox
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @cardbox
    assert_response :success
  end

  test "should update cardbox" do
    patch :update, id: @cardbox, cardbox: { deleted_at: @cardbox.deleted_at, name: @cardbox.name, user_id: @cardbox.user_id }
    assert_redirected_to cardbox_path(assigns(:cardbox))
  end

  test "should destroy cardbox" do
    assert_difference('Cardbox.count', -1) do
      delete :destroy, id: @cardbox
    end

    assert_redirected_to cardboxes_path
  end
end
