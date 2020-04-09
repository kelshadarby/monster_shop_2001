class UsersController < ApplicationController
  def new
    @user = User.new()
    @user.user_detail = UserDetail.new()
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
    flash[:success] = "Logged in as #{user.user_detail.name}"
  end

  def update
    user = User.find(current_user.id)
    user.user_detail.update(user_params)
    binding.pry
  end

  private

  def user_params
    params.permit(
      :email_address,
      :password,
      user_detail_attributes: [
        :name,
        :street_address,
        :city,
        :state,
        :zip_code
        ])
  end

end
