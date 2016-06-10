require 'test_helper'

class PhoneticsControllerTest < ActionController::TestCase
  setup do
    @phonetic = phonetics(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:phonetics)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create phonetic" do
    assert_difference('Phonetic.count') do
      post :create, phonetic: { content: @phonetic.content, deleted_at: @phonetic.deleted_at, label: @phonetic.label }
    end

    assert_redirected_to phonetic_path(assigns(:phonetic))
  end

  test "should show phonetic" do
    get :show, id: @phonetic
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @phonetic
    assert_response :success
  end

  test "should update phonetic" do
    patch :update, id: @phonetic, phonetic: { content: @phonetic.content, deleted_at: @phonetic.deleted_at, label: @phonetic.label }
    assert_redirected_to phonetic_path(assigns(:phonetic))
  end

  test "should destroy phonetic" do
    assert_difference('Phonetic.count', -1) do
      delete :destroy, id: @phonetic
    end

    assert_redirected_to phonetics_path
  end
end
