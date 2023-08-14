require "test_helper"

class InformationControllerTest < ActionDispatch::IntegrationTest
  test "should get about" do
    get information_about_url
    assert_response :success
  end
end
