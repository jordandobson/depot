require 'test_helper'

class AdminControllerTest < ActionController::TestCase

  def setup
      @user = users(:jordan)
  end

  test "should show login" do
    get :index
    assert_response :redirect
    assert_redirected_to :controller => "admin", :action => "login"
    assert_equal "Please log in", flash[:notice]
  end

  test "valid user can view index" do
    @request.session[:user_id] = @user.id
    get :index
    assert_response :success
    assert_template 'admin/index'
  end

  test "log user in" do
    post :login, :name => @user.name, :password => "dobson"
    assert_response :redirect
    assert_redirected_to :action => "index"
    assert_equal @user.id, session[:user_id]
  end

  test "error on password" do
    post :login, :name => @user.name, :password => "fail"
    assert_response :success
    assert_template 'admin/login'
    assert_nil session[:user_id]
    assert_equal "Invalid user/password combination", flash[:notice]
  end

  test "error on name and password" do
    post :login, :name => "fail", :password => "fail"
    assert_response :success
    assert_template 'admin/login'
    assert_nil session[:user_id]
    assert_equal "Invalid user/password combination", flash[:notice]
  end

  test "login error returns their info" do
    post :login, :name => "fail", :password => "fail"
    assert_tag :tag => 'input', :attributes => {
      :name   => 'name',
      :type => 'text',
      :value  =>  'fail'
    }
    assert_tag :tag => 'input', :attributes => {
      :name   => 'password',
      :type => 'password',
      :value  =>  'fail'
    }
  end
  
  test "user logout works" do
    post :logout
    assert_response :redirect
    assert_redirected_to :controller => "admin", :action => "login"
    assert_equal "Please log in", flash[:notice]
  end

  test "page redirect works" do
    get :controller => "products", :action => "index"
    assert_response :redirect
    assert_redirected_to :controller => "admin", :action => "login"
    post :login, :name => @user.name, :password => "dobson"
    assert_response :redirect
#   Not sure how to check if it goes back to products/index
#   assert_template 'products/index'
  end

end
