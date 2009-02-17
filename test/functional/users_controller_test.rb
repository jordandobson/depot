require 'test_helper'

class UsersControllerTest < ActionController::TestCase

  fixtures :users
 
  def setup
    @request.session[:user_id] = users(:jordan)
  end

  test "should get index view" do
    get :index
    assert_response :success
  end
end
