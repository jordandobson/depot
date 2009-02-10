require 'test_helper'

class CartTest < ActiveSupport::TestCase

  def test_init
    cart = Cart.new
    assert_equal 0, cart.items.length
  end

  def test_add_product
    cart = Cart.new
    cart.add_product products(:one)
    assert_equal 1, cart.items.length
    assert_equal 1099, cart.items[0].price
    assert_equal 1, cart.items[0].quantity
  end

  def test_add_two_different_products
    cart = Cart.new
    cart.add_product products(:one)
    cart.add_product products(:two)
    assert_equal 2, cart.items.length
    expected = products(:two).price + products(:one).price
    assert_equal expected, cart.total_price
  end

  def test_add_two_identical_products
    cart = Cart.new
    cart.add_product products(:one)
    cart.add_product products(:one)
    assert_equal 1, cart.items.length
    assert_equal 2, cart.items[0].quantity
    expected = 2 * products(:one).price
    assert_equal expected, cart.total_price
  end

  def test_removing_products
    cart = Cart.new
    cart.add_product products(:one)
    cart.add_product products(:one)
    assert_equal 1, cart.items.length
    assert_equal 2, cart.items[0].quantity
    cart.less_product products(:one).id
    assert_equal 1, cart.items[0].quantity
    cart.less_product products(:one).id
    assert_equal 0, cart.items.length
    assert_equal [], cart.items
  end

end