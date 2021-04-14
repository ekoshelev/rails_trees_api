require 'test_helper'

class HomeControllerTest < ActionDispatch::IntegrationTest
  test "should get common_ancestor" do
    get home_common_ancestor_url
    assert_response :success
  end

end
