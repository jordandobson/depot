# This file defines the order things should happen and how to respond

class StoreController < ApplicationController

  def index
    @cart = find_cart
    @products = Product.find_products_for_sale
    get_session
  end

  def add_to_cart
    begin
      product = Product.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      logger.error("Attempt to access invalid product #{params[:id]}")
      redirect_to_index "This product does not exist"
    else
      @cart = find_cart
      @current_item = @cart.add_product(product)
      session[:counter] = 0
      if request.xhr?
        respond_to { |format| format.js }
      else
        redirect_to_index
      end
    end
  end

  def remove_product
    @cart = find_cart
    @cart.less_product(params[:id].to_i)
    redirect_to_index
  end

  def empty_cart
    @cart = find_cart
    session[:cart] = nil
    if request.xhr?
      respond_to { |format| format.js }
    else
      redirect_to_index "Your Cart is Empty"
    end
  end

  private

  def redirect_to_index message = nil
    flash[:notice] = message if message
    redirect_to :action => :index
  end


  def find_cart
    session[:cart] ||= Cart.new
  end

  def get_session
    if session[:counter].nil?
      session[:counter] = 1
    else
      session[:counter] += 1
    end
  end

end
