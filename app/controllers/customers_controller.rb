class CustomersController < ApplicationController
  before_action :check_session, only: %i[ show ]

  # GET /mypage
  def show
    @customer = current_user
    @appoints = @customer.appoint
  end

  # GET /customers/new
  def new
    @customer = Customer.new
  end

  # POST /customers
  def create
    @customer = Customer.new(customer_params)

    if @customer.save
      log_in @customer
      redirect_to mypage_path, notice: 'アカウントの登録が完了しました'
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def check_session
    if logged_in?
      redirect_to staffs_mypage_path if is_staff?
    else
      redirect_to login_path   
    end
  end

  def customer_params
    params.require(:customer)
          .permit(:first_name,
                  :last_name,
                  :first_name_kana,
                  :last_name_kana,
                  :email,
                  :password,
                  :password_confirmation)
  end

end
