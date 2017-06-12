require 'test_helper'

class BooklistsControllerTest < ActionController::TestCase
  setup do
    @booklist = booklists(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:booklists)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create booklist" do
    assert_difference('Booklist.count') do
      post :create, booklist: { deleted_at: @booklist.deleted_at, serial: @booklist.serial, textbook_id: @booklist.textbook_id, user_id: @booklist.user_id }
    end

    assert_redirected_to booklist_path(assigns(:booklist))
  end

  test "should show booklist" do
    get :show, id: @booklist
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @booklist
    assert_response :success
  end

  test "should update booklist" do
    patch :update, id: @booklist, booklist: { deleted_at: @booklist.deleted_at, serial: @booklist.serial, textbook_id: @booklist.textbook_id, user_id: @booklist.user_id }
    assert_redirected_to booklist_path(assigns(:booklist))
  end

  test "should destroy booklist" do
    assert_difference('Booklist.count', -1) do
      delete :destroy, id: @booklist
    end

    assert_redirected_to booklists_path
  end
end
