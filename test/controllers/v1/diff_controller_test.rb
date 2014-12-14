require 'test_helper'

class V1::DiffControllerTest < ActionController::TestCase
  test "should get show" do
    get :show
    assert_response :success
  end

end
