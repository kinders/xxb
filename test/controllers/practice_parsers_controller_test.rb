require 'test_helper'

class PracticeParsersControllerTest < ActionController::TestCase
  setup do
    @practice_parser = practice_parsers(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:practice_parsers)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create practice_parser" do
    assert_difference('PracticeParser.count') do
      post :create, practice_parser: { deleted_at: @practice_parser.deleted_at, practice_id: @practice_parser.practice_id, word_id: @practice_parser.word_id }
    end

    assert_redirected_to practice_parser_path(assigns(:practice_parser))
  end

  test "should show practice_parser" do
    get :show, id: @practice_parser
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @practice_parser
    assert_response :success
  end

  test "should update practice_parser" do
    patch :update, id: @practice_parser, practice_parser: { deleted_at: @practice_parser.deleted_at, practice_id: @practice_parser.practice_id, word_id: @practice_parser.word_id }
    assert_redirected_to practice_parser_path(assigns(:practice_parser))
  end

  test "should destroy practice_parser" do
    assert_difference('PracticeParser.count', -1) do
      delete :destroy, id: @practice_parser
    end

    assert_redirected_to practice_parsers_path
  end
end
