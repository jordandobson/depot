require 'test_helper'

class StoreControllerTest < ActionController::TestCase

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:products)

    Product.find_products_for_sale.each do |product|
      assert_tag :tag => 'h3', :content => product.title
      act = (product.price/100.0)
      assert_match /#{act}/, @response.body
    end
  end

  test "should flash for invalid product" do
    get :add_to_cart, :id => "invalid"
    assert_response :redirect
    assert_redirected_to :action => "index"
    assert_equal "This product does not exist", flash[:notice]
  end

  test "should flash for empty cart" do
    get :empty_cart
    assert_response :redirect
    assert_redirected_to :action => "index"
    assert_equal "Your Cart is Empty", flash[:notice]
  end

  test "should add empty cart to session" do
    get :index
    assert session[:cart]
    assert_equal [], session[:cart].items
  end

  test "should add item to cart" do
    get :add_to_cart, :id => products(:one).id
    assert_response :redirect
    assert_nil flash[:notice]
    assert session[:cart]
    assert_not_equal [], session[:cart].items
    assert session[:cart].items[0].product
    assert_equal 1, session[:cart].items[0].quantity
  end
  
  test "should not show checkout page with empty cart" do
    get :checkout
    assert session[:cart]
    assert_equal [], session[:cart].items 
    assert_response :redirect
    assert_redirected_to :controller => :store, :action => :index
    assert_equal "Your Cart is Empty", flash[:notice]
  end

  test "should show new checkout page with cart items" do

    get :add_to_cart, :id => products(:one).id
    assert_response :redirect
    get :checkout
    assert_response :success
    assert_not_equal [], session[:cart].items
    assert_not_nil assigns(:order)
    assert_nil flash[:notice]
    assert_tag :tag => 'input', :attributes => {
      :name => 'order[name]'
    }
    assert_tag :tag => 'textarea', :attributes => {
      :name => 'order[address]'
    }
    assert_tag :tag => 'input', :attributes => {
      :name => 'order[email]'
    }
    assert_tag :tag => 'select', :attributes => {
      :name => 'order[pay_type]'
    }

  end

  test "should reload checkout with invalid order info" do

    get :add_to_cart, :id => products(:one).id
    get :checkout
    assert_response :success
    post :save_order, :order => {
        :name         => '',
        :address      => '',
        :email        => '',
        :pay_type     => ''
      }
    assert :success
    assert_template 'store/checkout'
    assert_match /<div .* id="errorExplanation">/, @response.body
    assert_match /<div .* id="errorExplanation">/, @response.body
    assert_match /<h2>5 errors/, @response.body

  end
  
  test "should save order with alert and clear cart" do
    get :add_to_cart, :id => products(:one).id
    get :checkout
    assert_response :success
    assert_difference('Order.count', 1) do
      post :save_order, :order => {
          :name         => 'Jordan Dobson',
          :address      => '1121 S. East Street, Tacoma, Wa 98405',
          :email        => 'bob@bob.com',
          :pay_type     => 'po'
      }
    end
    assert_nil session[:cart]
    assert_response :redirect
    assert_redirected_to :controller => :store, :action => :index
    assert flash[:notice]
  end

end

