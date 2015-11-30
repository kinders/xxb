require 'test_helper'

class ClassgroupscoresControllerTest < ActionController::TestCase
  setup do
    @classgroupscore = classgroupscores(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:classgroupscores)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create classgroupscore" do
    assert_difference('Classgroupscore.count') do
      post :create, classgroupscore: { deleted_at: @classgroupscore.deleted_at, domain: @classgroupscore.domain, memo: @classgroupscore.memo, score: @classgroupscore.score, team_id: @classgroupscore.team_id, user_id: @classgroupscore.user_id }
    end

    assert_redirected_to classgroupscore_path(assigns(:classgroupscore))
  end

  test "should show classgroupscore" do
    get :show, id: @classgroupscore
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @classgroupscore
    assert_response :success
  end

  test "should update classgroupscore" do
    patch :update, id: @classgroupscore, classgroupscore: { deleted_at: @classgroupscore.deleted_at, domain: @classgroupscore.domain, memo: @classgroupscore.memo, score: @classgroupscore.score, team_id: @classgroupscore.team_id, user_id: @classgroupscore.user_id }
    assert_redirected_to classgroupscore_path(assigns(:classgroupscore))
  end

  test "should destroy classgroupscore" do
    assert_difference('Classgroupscore.count', -1) do
      delete :destroy, id: @classgroupscore
    end

    assert_redirected_to classgroupscores_path
  end
end
