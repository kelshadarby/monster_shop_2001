class User::OrdersController < User::BaseController

  def index
    @orders =  current_user.orders
  end

  def show
   @order = Order.find(params[:order_id])
  end

  
end
