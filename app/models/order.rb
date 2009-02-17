class Order < ActiveRecord::Base
  PAYMENT_TYPES = [ 
    [ "Check", "check" ], 
    [ "Credit card", "cc" ], 
    [ "Purchase order", "po" ] 
  ] 

  has_many :line_items

  validates_presence_of :name, :address, :email, :pay_type
  validates_inclusion_of :pay_type, :in =>
    PAYMENT_TYPES.map {|disp, value| value}

  validates_format_of :email,
    :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i,
    :message => 'must be valid email address.'

  def add_line_items_from_cart(cart)
    cart.items.each do |item|
      li = LineItem.from_cart_item(item)
      line_items << li
    end
  end

end
