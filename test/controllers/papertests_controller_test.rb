require 'test_helper'

class PapertestsControllerTest < ActionController::TestCase
  setup do
    @papertest = papertests(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:papertests)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create papertest" do
    assert_difference('Papertest.count') do
      post :create, papertest: { deleted_at: @papertest.deleted_at, end_at: @papertest.end_at, paper_id: @papertest.paper_id, user_id: @papertest.user_id }
    end

    assert_redirected_to papertest_path(assigns(:papertest))
  end

  test "should show papertest" do
    get :show, id: @papertest
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @papertest
    assert_response :success
  end

  test "should update papertest" do
    patch :update, id: @papertest, papertest: { deleted_at: @papertest.deleted_at, end_at: @papertest.end_at, paper_id: @papertest.paper_id, user_id: @papertest.user_id }
    assert_redirected_to papertest_path(assigns(:papertest))
  end

  test "should destroy papertest" do
    assert_difference('Papertest.count', -1) do
      delete :destroy, id: @papertest
    end

    assert_redirected_to papertests_path
  end
end
