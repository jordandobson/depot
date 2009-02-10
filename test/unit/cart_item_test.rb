require 'test_helper'

class ItemTest < ActiveSupport::TestCase

  def setup
    @item = CartItem.new(products(:one))
  end
  
  def test_init
    assert_equal 1, @item.quantity
    assert_equal products(:one).price, @item.price
    assert_equal products(:one).title, @item.title
    assert_equal products(:one), @item.product
  end

  def test_quantity_increment
    @item.increment_quantity
    assert_equal 2, @item.quantity
  end

  def test_quantity_decerement
    @item.decrement_quantity
    assert_equal 0, @item.quantity
  end

  def test_title
    assert_equal products(:one).title, @item.title
  end

  def test_price
    assert_equal 1, @item.quantity
    assert_equal products(:one).price, @item.price
    @item.increment_quantity
    assert_equal products(:one).price * 2, @item.price
    @item.decrement_quantity
    assert_equal products(:one).price, @item.price    
  end

end