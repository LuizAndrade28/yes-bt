require "test_helper"

class PlaysControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get plays_new_url
    assert_response :success
  end

  test "should get create" do
    get plays_create_url
    assert_response :success
  end

  test "should get edit" do
    get plays_edit_url
    assert_response :success
  end

  test "should get update" do
    get plays_update_url
    assert_response :success
  end

  test "should get destroy" do
    get plays_destroy_url
    assert_response :success
  end
end
