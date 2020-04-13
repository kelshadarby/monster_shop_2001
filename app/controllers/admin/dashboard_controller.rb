class Admin::DashboardController < Admin::BaseController

  def index
    @pending_orders = Order.where(status: "pending")
    @packaged_orders = Order.where(status: "packaged")
    @shipped_orders = Order.where(status: "shipped")
    @canceled_orders = Order.where(status: "canceled")
  end

end
