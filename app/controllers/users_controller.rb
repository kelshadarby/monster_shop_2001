class UsersController < ApplicationController
  def new
    @user = User.new()
  end

  def create
    @user = User.new(user_params)
    if @user.save
      session[:user_id] = @user.id
      flash[:notice] = "Registration sucessful! You are now logged in."
      redirect_to profile_path
    else
      flash.now[:error] = @user.errors.full_messages.to_sentence
      render :new
    end
  end

  def edit
    @user = User.find(current_user.id)
  end

  def show
    if current_user
      user = User.find(current_user.id)
      flash[:success] = "Logged in as #{user.name}"
    else
      render file: "/public/404"
    end
  end

  def change_password
  end

  def update_password
    user = current_user
    user.update(password_params)
    if user.save
      flash[:notice] = "Password has been changed."
      redirect_to '/profile'
    else
      flash[:error] = "Passwords Must Match"
      redirect_to '/profile/change_password'
    end
  end

  def update
    @user = current_user
    @user.update(user_params)
    if @user.save
      flash[:notice] = "Your information has been updated."
      redirect_to '/profile'
    else
      flash.now[:error] = @user.errors.full_messages.to_sentence
      render :edit
    end
  end

  private

  def user_params
    params.permit(
      :email_address,
      :password,
      :name,
      :street_address,
      :city,
      :state,
      :zip_code
    )
  end

  def password_params
    params.permit(:password, :password_confirmation)
  end

end
