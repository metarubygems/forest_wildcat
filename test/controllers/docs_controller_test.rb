require 'test_helper'

class DocsControllerTest < ActionController::TestCase
  test 'should get hello' do
    get :hello
    assert_response :success
  end
end
