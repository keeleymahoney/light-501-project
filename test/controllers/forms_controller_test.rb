require "test_helper"

class FormsControllerTest < ActionDispatch::IntegrationTest
  test "should get create" do
    get forms_create_url
    assert_response :success
  end

  test "should get monitor" do
    get forms_monitor_url
    assert_response :success
  end

  test "should get respond" do
    get forms_respond_url
    assert_response :success
  end
end
