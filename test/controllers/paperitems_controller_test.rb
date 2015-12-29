require 'test_helper'

class PaperitemsControllerTest < ActionController::TestCase
  setup do
    @paperitem = paperitems(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:paperitems)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create paperitem" do
    assert_difference('Paperitem.count') do
      post :create, paperitem: { deleted_at: @paperitem.deleted_at, paper_id: @paperitem.paper_id, practice_id: @paperitem.practice_id, score: @paperitem.score, user_id: @paperitem.user_id }
    end

    assert_redirected_to paperitem_path(assigns(:paperitem))
  end

  test "should show paperitem" do
    get :show, id: @paperitem
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @paperitem
    assert_response :success
  end

  test "should update paperitem" do
    patch :update, id: @paperitem, paperitem: { deleted_at: @paperitem.deleted_at, paper_id: @paperitem.paper_id, practice_id: @paperitem.practice_id, score: @paperitem.score, user_id: @paperitem.user_id }
    assert_redirected_to paperitem_path(assigns(:paperitem))
  end

  test "should destroy paperitem" do
    assert_difference('Paperitem.count', -1) do
      delete :destroy, id: @paperitem
    end

    assert_redirected_to paperitems_path
  end
end
