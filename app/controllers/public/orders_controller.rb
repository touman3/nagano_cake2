class Public::OrdersController < ApplicationController
  before_action :authenticate_customer!

  def new
    @order = Order.new
    @customer = current_customer
    @addresses = current_customer.addresses
  end

  def confirm
    @order = Order.new(order_params)
    @customer = current_customer
    @cart_items = current_customer.cart_items
    @total = @cart_items.inject(0) { |sum, item| sum + item.subtotal }
    @order.shipping_cost = 800
    @sum = (@total + @order.shipping_cost)

    if params[:order][:select_address] == "0"
      @order.postal_code = @customer.postal_code
      @order.address = @customer.address
      @order.name = @customer.last_name + @customer.first_name
    elsif params[:order][:select_address] == "1"
      address = Address.find(params[:order][:address_id])
      @order.postal_code = address.postal_code
      @order.address = address.address
      @order.name = address.name
    elsif params[:order][:select_address] == "2"
      @order.postal_code = params[:order][:postal_code]
      @order.address = params[:order][:address]
      @order.name = params[:order][:name]
    end

  end

  def create
    @order = Order.new(order_params)
    @order.customer_id = current_customer.id
    @cart_items = current_customer.cart_items
    @order.save
    @cart_items.each do |cart_item|
      order_detail = @order.order_details.new
      order_detail.item_id = cart_item.item_id
      order_detail.amount = cart_item.amount
      order_detail.price = cart_item.item.price * 1.1
      order_detail.save
    end
    @cart_items.destroy_all
    redirect_to orders_thanks_path
  end

  def index
    @customer = current_customer
    @orders = current_customer.orders
  end

  def show
    @customer = current_customer
    @order = Order.find(params[:id])
    @order_details = @order.order_details
  end

  private

  def order_params
    params.require(:order).permit(:postal_code, :address, :name, :shipping_cost, :total_payment, :payment_method)
  end

  def order_detail_params
    params.require(:order_detail).permit(:price, :amount)
  end
end
