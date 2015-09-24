require 'test_helper'

class CadresControllerTest < ActionController::TestCase
  setup do
    @cadre = cadres(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:cadres)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create cadre" do
    assert_difference('Cadre.count') do
      post :create, cadre: { deleted_at: @cadre.deleted_at, member_id: @cadre.member_id, position: @cadre.position, user_id: @cadre.user_id }
    end

    assert_redirected_to cadre_path(assigns(:cadre))
  end

  test "should show cadre" do
    get :show, id: @cadre
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @cadre
    assert_response :success
  end

  test "should update cadre" do
    patch :update, id: @cadre, cadre: { deleted_at: @cadre.deleted_at, member_id: @cadre.member_id, position: @cadre.position, user_id: @cadre.user_id }
    assert_redirected_to cadre_path(assigns(:cadre))
  end

  test "should destroy cadre" do
    assert_difference('Cadre.count', -1) do
      delete :destroy, id: @cadre
    end

    assert_redirected_to cadres_path
  end
end
