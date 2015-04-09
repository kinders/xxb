require 'test_helper'

class MeControllerTest < ActionController::TestCase
  test "should get summary" do
    get :summary
    assert_response :success
  end

end
