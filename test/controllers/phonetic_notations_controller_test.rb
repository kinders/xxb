require 'test_helper'

class PhoneticNotationsControllerTest < ActionController::TestCase
  setup do
    @phonetic_notation = phonetic_notations(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:phonetic_notations)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create phonetic_notation" do
    assert_difference('PhoneticNotation.count') do
      post :create, phonetic_notation: { deleted_at: @phonetic_notation.deleted_at, phonetic_id: @phonetic_notation.phonetic_id, word_id: @phonetic_notation.word_id }
    end

    assert_redirected_to phonetic_notation_path(assigns(:phonetic_notation))
  end

  test "should show phonetic_notation" do
    get :show, id: @phonetic_notation
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @phonetic_notation
    assert_response :success
  end

  test "should update phonetic_notation" do
    patch :update, id: @phonetic_notation, phonetic_notation: { deleted_at: @phonetic_notation.deleted_at, phonetic_id: @phonetic_notation.phonetic_id, word_id: @phonetic_notation.word_id }
    assert_redirected_to phonetic_notation_path(assigns(:phonetic_notation))
  end

  test "should destroy phonetic_notation" do
    assert_difference('PhoneticNotation.count', -1) do
      delete :destroy, id: @phonetic_notation
    end

    assert_redirected_to phonetic_notations_path
  end
end
