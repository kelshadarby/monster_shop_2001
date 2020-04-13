class Merchant::ItemsController < Merchant::BaseController

  def index
    @merchant = Merchant.find(current_user.merchant.id)
  end

  def update
    item = Item.find(params[:id])
    if item.update(item_params)
      flash[:success] = "Item #{item.id} is " + active_message(item.active?)
    else
      flash[:error] = @item.errors.full_messages.to_sentence
    end
    redirect_to merchant_items_path
  end

  private

  def item_params
    params.permit(:name,:description,:price,:inventory,:image, :active?)
  end

  def active_message(active)
    active ? "for sale" : "not for sale"
  end
end