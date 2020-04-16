class Merchant::ItemsController < Merchant::BaseController

  def new
    @item = Item.new()
  end

  def show
    @merchant = Merchant.find(current_user.merchant.id)
    @item = Item.find(params[:id])
  end

  def edit
    @item = Item.find(params[:id])
  end

  def create
    merchant = Merchant.find(current_user.merchant.id)
    @item = merchant.items.new(item_params)
    if @item.save
      flash[:success] = "#{@item.name} has been created."
      flash[:notice] = "Item #{@item.name} is " + item_active_message(@item.active?)
      redirect_to merchant_items_path
    else
      flash.now[:error] = @item.errors.full_messages.to_sentence
      render :new
    end
  end

  def update
    @item = Item.find(params[:id])
    if @item.update(item_params)
      flash[:success] = "Item #{@item.id} is " + item_active_message(@item.active?)
      redirect_to merchant_items_path
    else
      flash[:error] = @item.errors.full_messages.to_sentence
      render :edit
    end
  end

  def destroy
    item = Item.find(params[:id])
    Review.where(item_id: item.id).destroy_all
    if item.destroy
      flash[:success] = "Item #{item.id} has been deleted"
    else
      flash[:error] = item.errors.full_messages.to_sentence
    end
    redirect_to merchant_items_path
  end

  private

  def item_params
    params.permit(:name,:description,:price,:inventory,:image,:active?)
  end
end
