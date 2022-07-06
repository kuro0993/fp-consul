class AppointsController < ApplicationController
  before_action :set_session
  before_action :set_appoint, only: %i[ show destroy ]
  before_action :check_customer_session, only: %i[ index new create ]
  before_action :check_session, only: %i[ show destroy ]

  # GET /appoints
  def index
    set_calendar
    @appoints = @session_user.appoint
  end

  # GET /appoints/1
  def show
  end

  # GET /appoints/new
  def new
    @appoint = Appoint.new

    day = params[:day]
    start_time = params[:start_time].to_time
    end_time = params[:end_time].to_time

    @start_datetime = Time.zone.local(
      day.to_time.year,
      day.to_time.month,
      day.to_time.day,
      start_time.hour,
      start_time.min
    )
    @end_datetime = Time.zone.local(
      day.to_time.year,
      day.to_time.month,
      day.to_time.day,
      end_time.hour,
      end_time.min
    )

    @staffs = StaffAppointFrame.can_appoint_staffs(@start_datetime, @end_datetime)
  end

  # GET /appoints/1/edit
  # def edit
  # end

  # POST /appoints
  def create
    @appoint = Appoint.new(appoint_params)
    @appoint.customer = @session_user

    if @appoint.save
      redirect_to appoint_path(@appoint), notice: '相談予約が完了しました'
    else
      @start_datetime = appoint_params[:start_datetime].to_time
      @end_datetime = appoint_params[:end_datetime].to_time
      @staffs = StaffAppointFrame.can_appoint_staffs(@start_datetime, @end_datetime)
      render :new, status: :unprocessable_entity
    end
  end

  # DELETE /appoints/1
  def destroy
    @appoint.destroy

    if is_staff?
      redirect_to staffs_mypage_path, notice: '相談予約をキャンセルしました'
    else
      redirect_to mypage_path, notice: '相談予約をキャンセルしました'
    end
  end

  private

  def set_session
    @session_user = current_user
  end

  def set_appoint
    @appoint = Appoint.find(params[:id])
  end

  def appoint_params
    params.require(:appoint).permit(:staff_id, :start_datetime, :end_datetime)
  end

  def set_calendar
    @start_date = !params[:start_date].nil? ? params[:start_date].to_time : Time.now
    beginning_of_week = @start_date.beginning_of_week
    end_of_week = @start_date.end_of_week
    @acceptable_dates = AppointService.get_can_appoint_dates(@start_date.year, @start_date.month)
    @acceptable_times = AppointService.get_can_appoint_times_term(beginning_of_week, end_of_week)
    @appoint_frame =  AppointService.get_frames
  end

  def check_customer_session
    if logged_in?
      redirect_to staffs_mypage_path if is_staff?
    else
      redirect_to login_path   
    end
  end

  def check_session
      redirect_to login_path unless logged_in?
  end
end
