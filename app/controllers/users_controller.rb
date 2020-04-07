class UsersController < ApplicationController
  def new
  end

  def create
    user = User.new(user_params)
    if user.save
      user.user_detail = UserDetail.new(user_detail_params)
      redirect_to '/profile'
      flash[:success] = "Registration sucessful! You are now logged in."
    else
      flash[:error] = "Registration unsucessful. Try again! 😱"
    end
  end

  def show

  end

  private
  def user_detail_params
    params.permit(:name,
                  :street_address,
                  :city,
                  :state,
                  :zip_code
                  )
  end
  def user_params
    params.permit(:email_address,
                  :password
                  )
  end
end
