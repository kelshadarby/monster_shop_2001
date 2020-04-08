class User::ProfileController < ApplicationController
  def index
    user = User.find(current_user.id)
    flash[:success] = "Logged in as #{user.user_detail.name}"
  end
end
