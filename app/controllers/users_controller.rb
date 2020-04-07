class UsersController < ApplicationController
  def new
  end

  def create
    user = User.new(user_params)
    if user.save
      detail = UserDetail.new(user_detail_params)
      detail.user_id = user.id
      if detail.valid?
        user.user_detail = detail
        flash[:success] = "Registration sucessful! You are now logged in."
        redirect_to '/profile'
      elsif detail.errors.messages.values.empty?
        flash[:error] = "Email is already in use."
        redirect_to '/register'
      else
        flash[:error] = "Registration unsucessful. Please fill in required fields. 😱"
        redirect_to '/register'
      end
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
