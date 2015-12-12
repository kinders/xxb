require 'test_helper'

class ReceiptsControllerTest < ActionController::TestCase
  setup do
    @receipt = receipts(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:receipts)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create receipt" do
    assert_difference('Receipt.count') do
      post :create, receipt: { active_time_after_charge: @receipt.active_time_after_charge, active_time_before_charge: @receipt.active_time_before_charge, cashier: @receipt.cashier, deleted_at: @receipt.deleted_at, money: @receipt.money, time_length: @receipt.time_length, user_id: @receipt.user_id }
    end

    assert_redirected_to receipt_path(assigns(:receipt))
  end

  test "should show receipt" do
    get :show, id: @receipt
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @receipt
    assert_response :success
  end

  test "should update receipt" do
    patch :update, id: @receipt, receipt: { active_time_after_charge: @receipt.active_time_after_charge, active_time_before_charge: @receipt.active_time_before_charge, cashier: @receipt.cashier, deleted_at: @receipt.deleted_at, money: @receipt.money, time_length: @receipt.time_length, user_id: @receipt.user_id }
    assert_redirected_to receipt_path(assigns(:receipt))
  end

  test "should destroy receipt" do
    assert_difference('Receipt.count', -1) do
      delete :destroy, id: @receipt
    end

    assert_redirected_to receipts_path
  end
end
