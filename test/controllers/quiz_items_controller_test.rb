require 'test_helper'

class QuizItemsControllerTest < ActionController::TestCase
  setup do
    @quiz_item = quiz_items(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:quiz_items)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create quiz_item" do
    assert_difference('QuizItem.count') do
      post :create, quiz_item: { deleted_at: @quiz_item.deleted_at, isright: @quiz_item.isright, practice_id: @quiz_item.practice_id, quiz_id: @quiz_item.quiz_id, user_id: @quiz_item.user_id }
    end

    assert_redirected_to quiz_item_path(assigns(:quiz_item))
  end

  test "should show quiz_item" do
    get :show, id: @quiz_item
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @quiz_item
    assert_response :success
  end

  test "should update quiz_item" do
    patch :update, id: @quiz_item, quiz_item: { deleted_at: @quiz_item.deleted_at, isright: @quiz_item.isright, practice_id: @quiz_item.practice_id, quiz_id: @quiz_item.quiz_id, user_id: @quiz_item.user_id }
    assert_redirected_to quiz_item_path(assigns(:quiz_item))
  end

  test "should destroy quiz_item" do
    assert_difference('QuizItem.count', -1) do
      delete :destroy, id: @quiz_item
    end

    assert_redirected_to quiz_items_path
  end
end
