class SessionsController < ApplicationController
  # GET /
  # GET /login
  def new
    redirect_to_mypage
  end

  # GET /staffs/login
  def new_staff
    redirect_to_mypage
  end

  # POST /login
  def create
    user = Customer.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      log_in user
      redirect_to mypage_path(user), notice: 'ようこそ'
    else
      render :new, status: :unprocessable_entity
    end
  end

  # POST /staffs/login
  def create_staff
    user = Staff.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      log_in user
      redirect_to staffs_mypage_path(user), notice: 'ようこそ'
    else
      render :new_staff, status: :unprocessable_entity
    end
  end

  # DELETE /logout
  def destroy
    if !is_staff?
      log_out
      redirect_to root_path
    else
      log_out
      redirect_to staffs_login_path
    end
  end

  private

  def redirect_to_mypage
    if logged_in? && !is_staff?
      redirect_to mypage_path(current_user)
    end
    if logged_in? && is_staff?
      redirect_to staffs_mypage_path(current_user)
    end
  end
end
