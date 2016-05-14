require 'test_helper'

class WordParsersControllerTest < ActionController::TestCase
  setup do
    @word_parser = word_parsers(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:word_parsers)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create word_parser" do
    assert_difference('WordParser.count') do
      post :create, word_parser: { deleted_at: @word_parser.deleted_at, lesson_id: @word_parser.lesson_id, word_id: @word_parser.word_id }
    end

    assert_redirected_to word_parser_path(assigns(:word_parser))
  end

  test "should show word_parser" do
    get :show, id: @word_parser
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @word_parser
    assert_response :success
  end

  test "should update word_parser" do
    patch :update, id: @word_parser, word_parser: { deleted_at: @word_parser.deleted_at, lesson_id: @word_parser.lesson_id, word_id: @word_parser.word_id }
    assert_redirected_to word_parser_path(assigns(:word_parser))
  end

  test "should destroy word_parser" do
    assert_difference('WordParser.count', -1) do
      delete :destroy, id: @word_parser
    end

    assert_redirected_to word_parsers_path
  end
end
