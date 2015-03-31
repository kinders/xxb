require 'test_helper'

class PracticesControllerTest < ActionController::TestCase
  setup do
    @practice = practices(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:practices)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create practice" do
    assert_difference('Practice.count') do
      post :create, practice: { activate: @practice.activate, answer: @practice.answer, lesson_id: @practice.lesson_id, question: @practice.question, title: @practice.title, tutor_id: @practice.tutor_id, user_id: @practice.user_id }
    end

    assert_redirected_to practice_path(assigns(:practice))
  end

  test "should show practice" do
    get :show, id: @practice
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @practice
    assert_response :success
  end

  test "should update practice" do
    patch :update, id: @practice, practice: { activate: @practice.activate, answer: @practice.answer, lesson_id: @practice.lesson_id, question: @practice.question, title: @practice.title, tutor_id: @practice.tutor_id, user_id: @practice.user_id }
    assert_redirected_to practice_path(assigns(:practice))
  end

  test "should destroy practice" do
    assert_difference('Practice.count', -1) do
      delete :destroy, id: @practice
    end

    assert_redirected_to practices_path
  end
end
