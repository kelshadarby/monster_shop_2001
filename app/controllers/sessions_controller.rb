class SessionsController < ApplicationController
  def new

  end

  def create
    user = User.find_by(email_address: params[:email_address])
    if user.authenticate(params[:password])
      session[:user_id] = user.id
      flash[:success] = "Welcome #{user.user_detail.name}"
      redirect_to '/'
    else
      flash[:error] = "Invalid Credentials"
      render :new
    end
  end

  def destroy
    redirect_to root_path
  end

end