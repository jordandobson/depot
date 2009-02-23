class StoreController < ApplicationController

  before_filter :get_session
  before_filter :find_cart, :except => :empty_cart

  def index
    @products = Product.find_products_for_sale
    get_session
    respond_to do |format|
      format.html
      format.xml { render :layout => false,
        :xml => @products.to_xml }
    end
  end

  def add_to_cart
    begin
      product = Product.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      logger.error("Attempt to access invalid product #{params[:id]}")
      redirect_to_index "This product does not exist"
    else
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
    @cart.less_product(params[:id].to_i)
    redirect_to_index
  end

  def empty_cart
    session[:cart] = nil
    if request.xhr?
      respond_to { |format| format.js }
    else
      redirect_to_index "Your Cart is Empty"
    end
  end

  # Test This
  def checkout
    if @cart.items.empty?
      redirect_to_index "Your Cart is Empty"
    else
      @order = Order.new
    end
  end

  # Test This
  def save_order
    @order = Order.new(params[:order])
    @order.add_line_items_from_cart(@cart)
    if @order.save
      session[:cart] = nil
      redirect_to_index(I18n.t('flash.thanks')) 
    else 
      render :action => :checkout 
    end 
  end

  private

  def redirect_to_index message = nil
    flash[:notice] = message if message
    redirect_to :action => :index
  end

  def find_cart
    @cart = (session[:cart] ||= Cart.new)
  end

  def get_session
    if session[:counter].nil?
      session[:counter] = 1
    else
      session[:counter] += 1
    end
  end

protected

  def authorize
  end


end
