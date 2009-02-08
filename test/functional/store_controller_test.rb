require 'test_helper'

class StoreControllerTest < ActionController::TestCase

  include ActionView::Helpers::NumberHelper

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:products)

    Product.find_products_for_sale.each do |product|
      assert_tag :tag => 'h3', :content => product.title

      act = (product.price/100.0)
      assert_match /#{act}/, @response.body

      # This hung me up quite a bit
      #assert @response.body =~ /#{act}/
      act = number_to_currency(product.price/100.0)
      #assert_equal "$10.99", act
      #raise act.inspect
      #assert_match /#{act}/, @response.body
      #assert !(@response.body =~ /#{act}/).nil?
    end
  end
end

