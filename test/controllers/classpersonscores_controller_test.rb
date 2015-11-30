require 'test_helper'

class ClasspersonscoresControllerTest < ActionController::TestCase
  setup do
    @classpersonscore = classpersonscores(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:classpersonscores)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create classpersonscore" do
    assert_difference('Classpersonscore.count') do
      post :create, classpersonscore: { classgroupscore_id: @classpersonscore.classgroupscore_id, deleted_at: @classpersonscore.deleted_at, member_id: @classpersonscore.member_id, score: @classpersonscore.score, user_id: @classpersonscore.user_id }
    end

    assert_redirected_to classpersonscore_path(assigns(:classpersonscore))
  end

  test "should show classpersonscore" do
    get :show, id: @classpersonscore
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @classpersonscore
    assert_response :success
  end

  test "should update classpersonscore" do
    patch :update, id: @classpersonscore, classpersonscore: { classgroupscore_id: @classpersonscore.classgroupscore_id, deleted_at: @classpersonscore.deleted_at, member_id: @classpersonscore.member_id, score: @classpersonscore.score, user_id: @classpersonscore.user_id }
    assert_redirected_to classpersonscore_path(assigns(:classpersonscore))
  end

  test "should destroy classpersonscore" do
    assert_difference('Classpersonscore.count', -1) do
      delete :destroy, id: @classpersonscore
    end

    assert_redirected_to classpersonscores_path
  end
end
