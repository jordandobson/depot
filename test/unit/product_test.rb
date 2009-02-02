require 'test_helper'

class ProductTest < ActiveSupport::TestCase
  test "product has price" do
    product = products(:one)
    product.title = "awesomeness"
    product.price = 1000
    product.image_url = "hello.jpg"
    product.save!
  end

  test "product validates presence of title" do
    product = Product.new
    assert ! product.valid?
    assert product.errors.on(:title)
  end

  test "product validates presence of description" do
    product = Product.new
    assert ! product.valid?
    assert product.errors.on(:description)
  end

  test "product validates presence of url" do
    product = Product.new
    assert ! product.valid?
    assert product.errors.on(:image_url)
  end
 
  test "that price must be a number" do
    product = products(:one)
    product.price = 'Twenty Cents'
    assert ! product.valid?
    assert product.errors.on(:price)
  end

  test "that the price must be at least one cent" do
    product = products(:one)

    product.title = "AwesomeVille"
    product.image_url = "hello.png"
    product.price = 0.01
    assert !product.valid?
    assert product.errors.on(:price)

    product.price = nil
    assert !product.valid?
    assert product.errors.on(:price)

    product.price = 1
    assert product.save!
  end

  test "that titles are unique" do
    product = Product.new(products(:one).attributes)
    assert ! product.valid?
    assert product.errors.on(:title)
  end

   test "urls must be formatted properly" do
    product1 = Product.new
    product1.title ="Awesomeville"
    product1.price = 0.01
    product1.image_url = 'hello.png'
    assert !product1.valid?
    product2 = Product.new
    product2.title ="Awesomeville"
    product2.price = 0.01
    product2.image_url = 'http://asdfasdfadsf'
    assert !product2.valid?
    assert product2.errors.on(:image_url)
   end

  test "find_products_for_sale" do
    sale_products = Product.find_products_for_sale
    assert sale_products
    assert_equal Product.find(:all).sort_by { |product|
      product.title
    }, sale_products
  end
end
