class Admin::Merchant::ItemsController < Admin::BaseController

  def index
    @merchant = Merchant.find(params[:id])
  end

  def update
    merchant = Merchant.find(params[:id])
    item = Item.find(params[:item_id])
    if item.update(item_params)
      flash[:success] = "Item #{item.id} is " + item_active_message(item.active?)
    end
    redirect_to admin_merchant_items_path
  end

  def destroy
    item = Item.find(params[:id])
    Review.where(item_id: item.id).destroy_all
    item.destroy
    redirect_to "/items"
  end

  def item_params
    params.permit(:name,:description,:price,:inventory,:image, :active?)
  end

end
