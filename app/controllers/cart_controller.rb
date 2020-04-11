class CartController < ApplicationController
  before_action :deny_admin

  def add_item
    item = Item.find(params[:item_id])
    cart.add_item(item.id.to_s)
    flash[:success] = "#{item.name} was successfully added to your cart"
    redirect_to "/items"
  end

  def show
    @items = cart.items
  end

  def update
    item = Item.find(params[:item_id])

    if params[:quantity] == "add" && (cart.contents[item.id.to_s] + 1) <= item.inventory
      cart.add_item(params[:item_id].to_s)
    elsif params[:quantity] == "subtract"
      cart.subtract_item(params[:item_id].to_s)
    end

    redirect_to '/cart'
  end

  def empty
    session.delete(:cart)
    redirect_to '/cart'
  end

  def remove_item
    session[:cart].delete(params[:item_id])
    redirect_to '/cart'
  end

  private

  def deny_admin
    render file: "/public/404" if current_admin?
  end

  # def increment_decrement
  #   if params[:increment_decrement] == "increment"
  #     cart.add_quantity(params[:item_id]) unless cart.limit_reached?(params[:item_id])
  #   elsif params[:increment_decrement] == "decrement"
  #     cart.subtract_quantity(params[:item_id])
  #     return remove_item if cart.quantity_zero?(params[:item_id])
  #   end
  #   redirect_to "/cart"
  # end
end
