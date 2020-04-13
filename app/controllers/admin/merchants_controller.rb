class Admin::MerchantsController < Admin::BaseController
  def index
    @merchants = Merchant.all
  end

  def disable
    merchant = Merchant.find(params[:merchant_id])
    merchant.disable
    flash[:success] = "#{merchant.name} has been disabled"
    redirect_to "/admin/merchants"
  end
end
