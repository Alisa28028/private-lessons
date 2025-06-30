require "test_helper"

class DashboardsControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get dashboards_show_url
    assert_response :success
  end

  test "should get select_preference" do
    get dashboards_select_preference_url
    assert_response :success
  end

  test "should get update_preference" do
    get dashboards_update_preference_url
    assert_response :success
  end
end
