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

end

