class SessionsController < ApplicationController
  def new
    dynamic_redirect unless current_user.nil?
  end

  def create
    user = User.find_by(email_address: params[:email_address])
    if user.nil?
      flash[:error] = "Invalid Credentials"
      render :new
    elsif user.authenticate(params[:password])
      session[:user_id] = user.id
      flash[:success] = "Welcome #{user.user_detail.name}"
      dynamic_redirect
    else
      flash[:error] = "Invalid Credentials"
      render :new
    end
  end

  def dynamic_redirect
    redirect_to "/profile" if current_user.role == "default"
    redirect_to "/merchant/dashboard" if current_user.role == "merchant"
    redirect_to "/admin/dashboard" if current_user.role == "admin"
  end
end
