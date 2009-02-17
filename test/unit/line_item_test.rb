require 'test_helper'

class LineItemTest < ActiveSupport::TestCase

  fixtures :products
  
  test "that cart items are added as line item" do
      product = products(:two)
      ci = CartItem.new(product)
      li = LineItem.from_cart_item(ci)
      assert_equal product, li.product
  end

end
