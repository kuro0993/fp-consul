module AppointsHelper
  def appoint_frame_time
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
    frames = []
    (10..17).each do |h|
      frames.push frame.new(h, 0, h, 30)
      frames.push frame.new(h, 30, h+1, 0)
    end
    frames
  end

  def check_appoint(acceptable_times, day, start_time, end_time)
    acceptable_times.each do |t|
      next unless t.start_time.strftime('%Y-%m-%d') == day.to_time.strftime('%Y-%m-%d') \
      && t.start_time.strftime('%H:%M') == start_time \
      && t.end_time.strftime('%H:%M') == end_time \
      && t.remaining_count.positive?

      return true
    end
    return false
  end
end
