class StaffAppointFramesController < ApplicationController
  before_action :check_session

  # GET /staffs_appoint_frames
  def index
  end

  private

  def check_session
    if logged_in?
      redirect_to mypage_path unless is_staff?
    else
      redirect_to staffs_login_path
    end
  end

  def set_calendar
    @start_date = !params[:start_date].nil? ? params[:start_date].to_time : Time.now
    beginning_of_week = @start_date.beginning_of_week
    end_of_week = @start_date.end_of_week
  end

end
