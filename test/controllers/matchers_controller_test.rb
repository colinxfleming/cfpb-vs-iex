require 'test_helper'

class MatchersControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get matchers_path
    assert_response :success
  end

end
