require "test_helper"

class RandomNumbersControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get random_numbers_index_url
    assert_response :success
  end
end
