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
      flash[:error] = @user.errors.full_messages.to_sentence
      render :new
    end
  end

  def edit
    @user = User.find(current_user.id)
  end

  def show
    user = User.find(current_user.id)
    flash[:success] = "Logged in as #{user.name}"
  end

  def update
    user = current_user
    user.update(user_params)
    if user.save
      flash[:notice] = "Your information has been updated."
      redirect_to '/profile'
    else
      flash[:error] = user.errors.full_messages.to_sentence
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

end
