require 'test_helper'
module V1
  class FilesControllerTest < ActionController::TestCase
    test 'should get show' do
      get :show
      assert_response :success
    end
  end
end
