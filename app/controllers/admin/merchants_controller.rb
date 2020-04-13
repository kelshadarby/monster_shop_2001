class Admin::MerchantsController < Admin::BaseController
  def index
    @merchants = Merchant.all
  end

  def update
    merchant = Merchant.find(params[:merchant_id])
    if merchant.active?
      merchant.disable
      merchant.items.each { |item| item.deactivate }
      flash[:disabled] = "#{merchant.name} has been disabled."
    else
      merchant.enable
      merchant.items.each { |item| item.activate }
      flash[:enabled] = "#{merchant.name} has been enabled."
    end
    redirect_to "/admin/merchants"
  end
end
