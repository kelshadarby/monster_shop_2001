class Merchant::BaseController < ApplicationController
  before_action :require_merchant
  
  def index
    @merchant = Merchant.find(current_user.merchant.id)
  end

private

  def require_merchant
     render file: "/public/404" unless current_merchant?
  end

end

