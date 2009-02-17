require 'test_helper'

class OrderTest < ActiveSupport::TestCase
  
  fixtures :products, :orders

  test "that blank order is invalid" do
    order = Order.new
    assert ! order.valid?
    assert order.errors.invalid?(:name)
    assert order.errors.invalid?(:address)
    assert order.errors.invalid?(:email)
    assert order.errors.invalid?(:pay_type)
  end

  test "that order has a name" do
    order = orders(:one)
    expected = "Jordan Dobson"
    order.name = expected
    assert order.save!
    assert_equal expected, order.name
  end

  test "that order has an address" do
    order = orders(:one)
    expected = "1 First Ave., Tacoma, WA 98405"
    order.address = expected
    assert order.save!
    assert_equal expected, order.address
  end

  test "that order has an email" do
    order = orders(:one)
    expected = "hello@madebysquad.com"
    order.email = expected
    assert order.save!
    assert_equal expected, order.email
  end

  test "that order errors on valid email" do
    order = orders(:one)
    expected = "hello[at]madebysquad[dot]com"
    order.email = expected
    assert ! order.valid?
    assert order.errors.on(:email)
  end

  test "that order has a pay type" do
    order = orders(:one)
    expected = "po"
    order.pay_type = expected
    assert order.save!
    assert_equal expected, order.pay_type
  end

  test "that pay type must be in constant" do
    order = orders(:one)
    order.pay_type = "PayPal"
    assert ! order.valid?
    assert order.errors.on(:pay_type)
  end

  test "that line items get added from cart" do
    order = Order.new
    cart = Cart.new
    assert_equal [], cart.items
    cart.add_product products(:one)
    assert_equal 1, cart.items.length
    cart.add_product products(:two)
    li = order.add_line_items_from_cart(cart)
    assert_equal 2, li.length
    assert_equal products(:one), li.first.product
  end

end