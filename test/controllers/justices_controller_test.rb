require 'test_helper'

class JusticesControllerTest < ActionController::TestCase
  setup do
    @justice = justices(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:justices)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create justice" do
    assert_difference('Justice.count') do
      post :create, justice: { activity: @justice.activity, evaluation_id: @justice.evaluation_id, remark: @justice.remark, score: @justice.score, user_id: @justice.user_id }
    end

    assert_redirected_to justice_path(assigns(:justice))
  end

  test "should show justice" do
    get :show, id: @justice
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @justice
    assert_response :success
  end

  test "should update justice" do
    patch :update, id: @justice, justice: { activity: @justice.activity, evaluation_id: @justice.evaluation_id, remark: @justice.remark, score: @justice.score, user_id: @justice.user_id }
    assert_redirected_to justice_path(assigns(:justice))
  end

  test "should destroy justice" do
    assert_difference('Justice.count', -1) do
      delete :destroy, id: @justice
    end

    assert_redirected_to justices_path
  end
end
