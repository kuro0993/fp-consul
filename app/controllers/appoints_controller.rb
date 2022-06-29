class AppointsController < ApplicationController

  def index
    @customer = Customer.find(1)
    @appoint = @customer.appoint
  end

  def new
    @start_date = !params[:start_date].nil? ? params[:start_date].to_time : Time.now
    @appoint = Appoint.new
    @acceptable_dates = AppointService::get_can_appoint_dates(@start_date.year, @start_date.month)
    @acceptable_times = AppointService::get_can_appoint_times(@start_date)
  end

  def create
    @appoint = Appoint.new do |apo|
      apo.staff = Staff.find(1)
      apo.customer = Customer.find(1)
      apo.acceptable_frame_start = Time.zone.local(2022,7,1,10,0)
      apo.acceptable_frame_end = Time.zone.local(2022,7,1,10,30)
    end

    if @appoint.save
      redirect_to @appoint
    else
      render :new, status: :unprocessable_entity
    end
  end

end
