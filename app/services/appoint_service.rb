class AppointService
  
  # 受付可能日
  def self.get_can_appoint_dates(year, month)
    start_day = Time.zone.local(year,month)
    end_day = Time.zone.local(year,month).end_of_month
    
    # 日別集計
    appoints = Appoint.aggregate_daily(start_day, end_day)
    acceptable_frames = StaffAppointFrame.aggregate_daily(start_day, end_day)

    # 残予約枠
    remaining_apo_frames = acceptable_frames.merge(appoints) {|key, frame, apo| frame - apo}

    list = []
    remaining_apo_frames.each do |k, v|
      list.push(Struct.new(:start_time, :end_time, :remaining_count).new(k.to_time, k.to_time + Constants::APPOINT_FRAME_MINUTES * 60, v))
    end
    list
  end

  # 日別受付可能枠時間
  def self.get_can_appoint_times(date)
    start_time = BusinessTimeMaster.start_of_biz(date)
    end_time =  BusinessTimeMaster.end_of_biz(date)
    
    # 時間別集計
    appoints = Appoint.aggregate_hourly(start_time, end_time)
    acceptable_frames = StaffAppointFrame.aggregate_hourly(start_time, end_time)

    # 残予約枠
    remaining_apo_frames = acceptable_frames.merge(appoints) {|key, frame, apo| frame - apo}

    list = []
    remaining_apo_frames.each do |k, v|
      list.push(Struct.new(:start_time, :end_time, :remaining_count).new(k.to_time, k.to_time + Constants::APPOINT_FRAME_MINUTES * 60, v))
    end
    list
  end

  # 予約枠一覧
  def self.get_frames
    frame_list = []
    (10..17).each do |h|
      frame_list.push({
        start_time: "#{h}:00",
        end_time: "#{h}:30"
      })
      frame_list.push({
        start_time: "#{h}:30",
        end_time: "#{h + 1}:00"
      })
    end
    frame_list
  end

end