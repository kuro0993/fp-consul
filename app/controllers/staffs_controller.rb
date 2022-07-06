class StaffsController < ApplicationController
  before_action :check_session, only: %i[ mypage index show new create ]

  # GET /staff/mypage
  def mypage
    @staff = current_user
    @appoints = @staff.appoint
  end

  # GET /staffs
  def index
    @staffs = Staff.all
  end

  # GET /staffs/:id
  def show
    @staff = Staff.find(params[:id])
  end

  # GET /staffs/new
  def new
    @staff = Staff.new
  end

  # POST /staffs
  def create
    @staff = Staff.new(staff_params)

    if @staff.save
      redirect_to staff_url(@staff), notice: 'アカウントの登録が完了しました'
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def check_session
    if logged_in?
      redirect_to mypage_path unless is_staff?
    else
      redirect_to staffs_login_path
    end
  end

  def staff_params
    params.require(:staff)
          .permit(:first_name,
                  :last_name,
                  :first_name_kana,
                  :last_name_kana,
                  :email,
                  :password,
                  :password_confirmation)
  end

end
