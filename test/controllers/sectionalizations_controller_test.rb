require 'test_helper'

class SectionalizationsControllerTest < ActionController::TestCase
  setup do
    @sectionalization = sectionalizations(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:sectionalizations)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create sectionalization" do
    assert_difference('Sectionalization.count') do
      post :create, sectionalization: { classroom_id: @sectionalization.classroom_id, deleted_at: @sectionalization.deleted_at, name: @sectionalization.name, user_id: @sectionalization.user_id }
    end

    assert_redirected_to sectionalization_path(assigns(:sectionalization))
  end

  test "should show sectionalization" do
    get :show, id: @sectionalization
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @sectionalization
    assert_response :success
  end

  test "should update sectionalization" do
    patch :update, id: @sectionalization, sectionalization: { classroom_id: @sectionalization.classroom_id, deleted_at: @sectionalization.deleted_at, name: @sectionalization.name, user_id: @sectionalization.user_id }
    assert_redirected_to sectionalization_path(assigns(:sectionalization))
  end

  test "should destroy sectionalization" do
    assert_difference('Sectionalization.count', -1) do
      delete :destroy, id: @sectionalization
    end

    assert_redirected_to sectionalizations_path
  end
end
