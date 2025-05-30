require "test_helper"

class ReactionsControllerTest < ActionDispatch::IntegrationTest
  test "should get create" do
    get reactions_create_url
    assert_response :success
  end
end
