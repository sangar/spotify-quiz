require 'test_helper'

class MainControllerTest < ActionDispatch::IntegrationTest
  test "should get login" do
    get main_login_url
    assert_response :success
  end

  test "should get playlist" do
    get main_playlist_url
    assert_response :success
  end

  test "should get start" do
    get main_start_url
    assert_response :success
  end

  test "should get quiz" do
    get main_quiz_url
    assert_response :success
  end

  test "should get summary" do
    get main_summary_url
    assert_response :success
  end

end
