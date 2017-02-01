require 'test_helper'

class AppControllerTest < ActionDispatch::IntegrationTest
  test "should get start" do
    get app_start_url
    assert_response :success
  end

end
