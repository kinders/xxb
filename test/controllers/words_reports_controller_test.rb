require 'test_helper'

class WordsReportsControllerTest < ActionController::TestCase
  setup do
    @words_report = words_reports(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:words_reports)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create words_report" do
    assert_difference('WordsReport.count') do
      post :create, words_report: { deleted_at: @words_report.deleted_at, lesson_id: @words_report.lesson_id, md: @words_report.md }
    end

    assert_redirected_to words_report_path(assigns(:words_report))
  end

  test "should show words_report" do
    get :show, id: @words_report
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @words_report
    assert_response :success
  end

  test "should update words_report" do
    patch :update, id: @words_report, words_report: { deleted_at: @words_report.deleted_at, lesson_id: @words_report.lesson_id, md: @words_report.md }
    assert_redirected_to words_report_path(assigns(:words_report))
  end

  test "should destroy words_report" do
    assert_difference('WordsReport.count', -1) do
      delete :destroy, id: @words_report
    end

    assert_redirected_to words_reports_path
  end
end
