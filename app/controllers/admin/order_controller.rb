class Admin::OrderController < Admin::BaseController

  def ship
    Order.find(params[:id]).ship
    redirect_to admin_path
  end
end
