require 'test_helper'

class ProductsControllerTest < ActionController::TestCase

  fixtures :users
 
  def setup
    @request.session[:user_id] = users(:jordan).id
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:products)
  end

  test "should get new" do
    get :new
    assert_response :success
    assert_tag :tag => 'input', :attributes => {
      :name => 'product[title]'
    }
    assert_tag :tag => 'textarea', :attributes => {
      :name => 'product[description]'
    }
    assert_tag :tag => 'input', :attributes => {
      :name => 'product[image_url]'
    }
    assert_tag :tag => 'input', :attributes => {
      :name => 'product[price]'
    }
  end

  test "should create product" do
    assert_difference('Product.count') do
      post :create, :product => {
        :title        => 'awesome product',
        :description  => 'awesome product description',
        :image_url    => 'http://example.com/foo.gif',
        :price        => '100'
      }
    end

    assert_redirected_to product_path(assigns(:product))
  end

  test "should throw title error" do
    post :create, :product => {
        :title        => '',
        :description  => 'awesome product description',
        :image_url    => 'http://example.com/foo.gif',
        :price        => '500'
      }
    assert_template 'products/new'
    assert_select "div#errorExplanation h2", "2 errors prohibited this product from being saved"
    assert_select "div#errorExplanation ul li:first-child", "Title can't be blank"
    assert_select "div.fieldWithErrors label", "Title"
    assert "div.fieldWithErrors input[name*=title]"
  end

  test "should show product" do
    get :show, :id => products(:one).id
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => products(:one).id
    assert_tag :tag => 'input', :attributes => {
      :name => 'product[title]'
    }
    assert_tag :tag => 'textarea', :attributes => {
      :name => 'product[description]'
    }
    assert_tag :tag => 'input', :attributes => {
      :name => 'product[image_url]'
    }
    assert_tag :tag => 'input', :attributes => {
      :name => 'product[price]'
    }
    assert_response :success
  end

  test "should update product" do
    put :update, :id => products(:one).id, :product => {
      :title => 'mega awesome title'
    }
    assert_redirected_to product_path(assigns(:product))

    assert_equal 'mega awesome title', Product.find(products(:one).id).title
  end

  test "should destroy product" do
    assert_difference('Product.count', -1) do
      delete :destroy, :id => products(:one).id
    end

    assert_redirected_to products_path
  end

end
