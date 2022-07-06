class CustomersController < ApplicationController

  def show
    @customer = current_user
    @appoints = @customer.appoint

  end

  def new
    @customer = Customer.new
  end

  def create
    @customer = Customer.new(customer_params)

    if @customer.save
      log_in @customer
      redirect_to customer_url(@customer), notice: 'アカウントの登録が完了しました'
    else
      render :new, status: :unprocessable_entity
    end

  end
  private

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
