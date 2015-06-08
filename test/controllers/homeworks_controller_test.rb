require 'test_helper'

class HomeworksControllerTest < ActionController::TestCase
  setup do
    @homework = homeworks(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:homeworks)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create homework" do
    assert_difference('Homework.count') do
      post :create, homework: { classroom_id: @homework.classroom_id, deleted_at: @homework.deleted_at, description: @homework.description, subject: @homework.subject, title: @homework.title, user_id: @homework.user_id }
    end

    assert_redirected_to homework_path(assigns(:homework))
  end

  test "should show homework" do
    get :show, id: @homework
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @homework
    assert_response :success
  end

  test "should update homework" do
    patch :update, id: @homework, homework: { classroom_id: @homework.classroom_id, deleted_at: @homework.deleted_at, description: @homework.description, subject: @homework.subject, title: @homework.title, user_id: @homework.user_id }
    assert_redirected_to homework_path(assigns(:homework))
  end

  test "should destroy homework" do
    assert_difference('Homework.count', -1) do
      delete :destroy, id: @homework
    end

    assert_redirected_to homeworks_path
  end
end
