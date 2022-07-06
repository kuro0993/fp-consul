class SessionsController < ApplicationController
  def new
    if logged_in?
      redirect_to mypage_path(current_user)
    end
  end
  def create
    # CustomerSession
    user = Customer.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      log_in user
      redirect_to mypage_path(user), notice: 'ようこそ'
    else
      render :new, status: :unprocessable_entity
    end
  end
  def destroy
    log_out
    redirect_to root_path
  end
end
