require 'test_helper'

class WithdrawsControllerTest < ActionController::TestCase
  setup do
    @withdraw = withdraws(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:withdraws)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create withdraw" do
    assert_difference('Withdraw.count') do
      post :create, withdraw: { memo: @withdraw.memo, money: @withdraw.money, user_id: @withdraw.user_id }
    end

    assert_redirected_to withdraw_path(assigns(:withdraw))
  end

  test "should show withdraw" do
    get :show, id: @withdraw
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @withdraw
    assert_response :success
  end

  test "should update withdraw" do
    patch :update, id: @withdraw, withdraw: { memo: @withdraw.memo, money: @withdraw.money, user_id: @withdraw.user_id }
    assert_redirected_to withdraw_path(assigns(:withdraw))
  end

  test "should destroy withdraw" do
    assert_difference('Withdraw.count', -1) do
      delete :destroy, id: @withdraw
    end

    assert_redirected_to withdraws_path
  end
end
