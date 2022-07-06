class BusinessTimeMaster < ApplicationRecord
  validates :weekday_id, presence: true, numericality: { in: 0..6 }, uniqueness: true
  validates :weekday, presence: true
  validates :start_time, :end_time, presence: false

  # 営業時間取得
  def self.get_biz_time(date)
    weekday = Time.zone.parse(date.to_s).wday
    BusinessTimeMaster.find_by(weekday_id: weekday)
  end

  # 営業開始時間
  def self.start_of_biz(date)
    biz_time = BusinessTimeMaster.get_biz_time(date)
    return nil if biz_time.start_time.nil?

    Time.zone.local(date.year, date.month, date.day, biz_time.start_time.hour, biz_time.start_time.min)
  end

  # 営業終了時間
  def self.end_of_biz(date)
    biz_time = BusinessTimeMaster.get_biz_time(date)
    return nil if biz_time.end_time.nil?

    Time.zone.local(date.year, date.month, date.day, biz_time.end_time.hour, biz_time.end_time.min)
  end

  # 営業時間内チェック
  def self.check_biz_time(target_datetime)
    biz_time = get_biz_time(target_datetime)
    return false if biz_time.start_time.nil?

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
