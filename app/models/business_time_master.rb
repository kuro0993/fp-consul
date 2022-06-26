class BusinessTimeMaster < ApplicationRecord
  validates :weekday_id, presence: true, numericality: { in: 1..7 }, uniqueness: true
  validates :weekday, presence: true
  validates :start_time, :end_time, presence: false

  # 営業時間内チェック
  def self.check_biz_time(target_datetime)
    weekday = Time.zone.parse(target_datetime.to_s).wday
    biz_time = BusinessTimeMaster.find_by(weekday_id: weekday)

    t_datetime = BusinessTimeMaster.cast_time_to_i(target_datetime)

    biz_start = BusinessTimeMaster.cast_time_to_i(biz_time.start_time)
    biz_end = BusinessTimeMaster.cast_time_to_i(biz_time.end_time)
    
    (t_datetime >= biz_start && t_datetime <= biz_end)
  end

  # 時刻比較用変換
  def self.cast_time_to_i(time)
    time.strftime('%H%M').to_i
  end
end
