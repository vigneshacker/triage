require 'test_helper'

class RequestsControllerTest < ActionController::TestCase
  setup do
    sign_in users :valid
  end

  test 'that the index action works' do
    get :index
    assert_response :success
  end

  test 'that users can only see their requests' do
    get :index
    assert_equal 1, assigns(:requests).count
  end
end
