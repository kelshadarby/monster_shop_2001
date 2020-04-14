class Merchant::ItemsController < Merchant::BaseController

  def update
    item = Item.find(params[:id])
    if item.update(item_params)
      flash[:success] = "Item #{item.id} is " + item_active_message(item.active?)
    else
      flash[:error] = item.errors.full_messages.to_sentence
    end
    redirect_to merchant_items_path
  end

  private

  def item_params
    params.permit(:name,:description,:price,:inventory,:image, :active?)
  end

end