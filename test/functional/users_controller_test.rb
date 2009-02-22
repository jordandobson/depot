require 'test_helper'

class UsersControllerTest < ActionController::TestCase 

  fixtures :users
 
  def setup
    @request.session[:user_id] = users(:jordan)
  end

  test "should get index view" do
    get :index
    assert_response :success
    assert_not_nil assigns(:users)
  end

  test "should not link to show" do
    get :index
    # assert_no_tag :tag => "a", :attributes => { :href => user_path(users(:jordan)) , :onclick => "" }
    # assert_no_match /<a href="#{user_path(users(:jordan))}" >/, @response.body
    assert_no_match /<a.href="#{user_path(users(:jordan))}".?(onclick){0}>/, @response.body
  end

  test "should not show user info" do
    assert_raise(ActionController::UnknownAction){
      get :show
    }
  end

  test "should get new" do
    get :new
    assert_response :success
    assert_tag :tag => 'input', :attributes => {
      :name => 'user[name]'
    }
    assert_tag :tag => 'input', :attributes => {
      :name => 'user[password]', :type => 'password'
    }
    assert_tag :tag => 'input', :attributes => {
      :name => 'user[password_confirmation]', :type => 'password'
    }
    assert_tag :tag => 'input', :attributes => {
      :name => 'commit', :type => 'submit'
    }
  end

  test "should create user" do
    assert_difference('User.count') do
      post :create, :user => {
        :name                     => 'elvis',
        :password                 => 'thankyouverymuch',
        :password_confirmation    => 'thankyouverymuch'
      }
    end
    assert_response :redirect
    assert_redirected_to users_path
  end

  test "should throw password error" do
    post :create, :user => {
        :name                     => 'elvis',
        :password                 => 'thankyouverymuch',
        :password_confirmation    => 'thankyou'
      }
    assert_template 'users/new'
    assert_select "div#errorExplanation h2", "1 error prohibited this user from being saved"
    assert_select "div#errorExplanation ul li:first-child", "Password doesn't match confirmation"
    assert "div.fieldWithErrors input[name*=user[password]]"
  end

  test "should throw error on blank password" do
    post :create, :user => {
        :name                     => 'elvis',
        :password                 => '',
        :password_confirmation    => ''
      }
    assert_template 'users/new'
    assert_select "div#errorExplanation h2", "1 error prohibited this user from being saved"
    assert_select "div#errorExplanation ul li:first-child", "Missing password"
  end

  test "should error on duplicate username" do
    expected = User.count
    post :create, :user => {
      :name                     => users(:jordan).name,
      :password                 => 'thankyouverymuch',
      :password_confirmation    => 'thankyouverymuch'
    }
    assert_template 'users/new'
    assert_equal expected, User.count
    assert_tag :tag => 'div', :attributes => {
      :id => 'errorExplanation'
    }
    assert "div.fieldWithErrors input[name*=user[name]]"
  end

  test "should get edit" do
    get :edit, :id => users(:liz).id
    assert_tag :tag => 'input', :attributes => {
      :name => 'user[name]'
    }
    assert_tag :tag => 'input', :attributes => {
      :name => 'user[hashed_password]', :type => 'hidden'
    }
    assert_tag :tag => 'input', :attributes => {
      :name => 'user[salt]', :type => 'hidden'
    }
    assert_response :success
  end

  test "should update username" do
    put :update, :id => users(:liz).id, :user => {
      :name => 'elizabeth'
    }
    assert_redirected_to users_path
    assert_equal 'elizabeth', User.find(users(:liz).id).name
  end

  test "should destroy user" do
    assert_difference('User.count', -1) do
      delete :destroy, :id => users(:liz).id
    end
    assert_redirected_to users_path
  end

  # should this also be in Unit tests?
  test "should not destroy last user account" do
    assert_raise RuntimeError do
      @users = User.find(:all)
      for user in @users
        user.destroy
      end
    end
  end

end
