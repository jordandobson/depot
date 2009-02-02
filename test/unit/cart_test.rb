# require 'test_helper'
# 
# class CartTest < ActiveSupport::TestCase
# 
# 
#   def initialize
#     cart = Cart.net
#     assert_equal 0, cart.items.length
#   end
# 
#   def test_add_product
#     cart = Cart.new
#     # cart.add_product products(:one)
#     cart << products(:one)
#     assert_equal 1, cart.items.length
#   end
# 
# end