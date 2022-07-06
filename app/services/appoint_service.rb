class AppointService
  # 受付可能日
  def self.get_can_appoint_dates(year, month)
    start_day = Time.zone.local(year,month)
    end_day = Time.zone.local(year,month).end_of_month

    # 日別集計
    appoints = Appoint.aggregate_daily(start_day, end_day)
    acceptable_frames = StaffAppointFrame.aggregate_daily(start_day, end_day)

    # 残予約枠
    remaining_apo_frames = acceptable_frames.merge(appoints) { |_, frame, apo| frame - apo }

    list = []
    remaining_apo_frames.each do |k, v|
      list.push Struct.new(:start_time, :end_time, :remaining_count)
                      .new(k.to_time, k.to_time + Constants::APPOINT_FRAME_MINUTES * 60, v)
    end
    list
  end

  # 日別受付可能枠時間
  def self.get_can_appoint_times(date)
    start_time = BusinessTimeMaster.start_of_biz(date)
    end_time = BusinessTimeMaster.end_of_biz(date)
    [] if start_time.nil? || end_time.nil?

    # 時間別集計
    appoints = Appoint.aggregate_hourly(start_time, end_time)
    acceptable_frames = StaffAppointFrame.aggregate_hourly(start_time, end_time)

    # 残予約枠
    remaining_apo_frames = acceptable_frames.merge(appoints) {|key, frame, apo| frame - apo}

    list = []
    remaining_apo_frames.each do |k, v|
      list.push(Struct.new(:start_time, :end_time, :remaining_count)
                      .new(k.to_time, k.to_time + Constants::APPOINT_FRAME_MINUTES * 60, v))
    end
    list
  end

  # 期間内の受付可能枠時間
  def self.get_can_appoint_times_term(start_day, end_day)
    # 時間別集計
    appoints = Appoint.aggregate_hourly(start_day, end_day.end_of_day)
    acceptable_frames = StaffAppointFrame.aggregate_hourly(start_day, end_day.end_of_day)

    # 残予約枠
    remaining_apo_frames = acceptable_frames.merge(appoints) { |_, frame, apo| frame - apo }

    list = []
    remaining_apo_frames.each do |k, v|
      list.push(Struct.new(:start_time, :end_time, :remaining_count)
                      .new(k.to_time, k.to_time + Constants::APPOINT_FRAME_MINUTES * 60, v))
    end
    list
  end

  # 予約枠一覧
  def self.get_frames
    frame = Struct.new(:start_hour, :start_minute, :end_hour, :end_minute) do |s|
      def start_time
        format('%02d', start_hour) + ':' + format('%02d', start_minute) 
      end
      def end_time
        format('%02d', end_hour) + ':' + format('%02d', end_minute) 
      end
      def frame_id
        format('%02d', start_hour) + format('%02d', start_minute) + '-' + format('%02d', end_hour) + format('%02d', end_minute) 
      end
      def label
        "#{start_time}〜#{end_time}"
      end
    end
    frame_list = []
    (10..17).each do |h|
      frame_list.push frame.new(h, 0, h, 30)
      frame_list.push frame.new(h, 30, h + 1, 30)
    end
    frame_list
  end
end
