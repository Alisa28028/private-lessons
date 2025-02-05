require "test_helper"

class EventInstancesControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get event_instances_new_url
    assert_response :success
  end

  test "should get create" do
    get event_instances_create_url
    assert_response :success
  end

  test "should get edit" do
    get event_instances_edit_url
    assert_response :success
  end

  test "should get update" do
    get event_instances_update_url
    assert_response :success
  end

  test "should get destroy" do
    get event_instances_destroy_url
    assert_response :success
  end
end
