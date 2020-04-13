class Admin::MerchantsController < Admin::BaseController
  def index
    @merchants = Merchant.all
  end

  def update
    merchant = Merchant.find(params[:merchant_id])
    if merchant.active?
      merchant.disable
      flash[:disabled] = "#{merchant.name} has been disabled."
    else
      merchant.enable
      flash[:enabled] = "#{merchant.name} has been enabled."
    end
    redirect_to "/admin/merchants"
  end

  def show
    @merchant = Merchant.find(params[:merchant_id])
  end
end
