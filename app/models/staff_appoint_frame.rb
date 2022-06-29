class StaffAppointFrame < ApplicationRecord
  belongs_to :staff

  validates :acceptable_frame_start, presence: true
  validates :acceptable_frame_end, presence: true
  validates :staff, presence: true, uniqueness: { scope: [:acceptable_frame_start, :acceptable_frame_end] }

  validates :acceptable_frame_end, comparison: { greater_than: :acceptable_frame_start }
  validate :check_frame_time

  def check_frame_time
    if (acceptable_frame_end - acceptable_frame_start) / 60 != Constants::APPOINT_FRAME_MINUTES then
      errors.add('受付予約枠は1枠30分で設定する必要があります')
    end
    if !(BusinessTimeMaster.check_biz_time(acceptable_frame_start) \
      && BusinessTimeMaster.check_biz_time(acceptable_frame_end)) then
      errors.add('受付予約枠が営業時間外です')
    end
  end

  # 予約可能枠 日別集計
  def self.aggregate_daily(start_day, end_day)
    StaffAppointFrame
      .where(acceptable_frame_start: start_day..end_day)
      .group("DATE_FORMAT(acceptable_frame_start, '%Y-%m-%d')")
      .count
  end

  # 予約可能枠 時間別集計
  def self.aggregate_hourly(start_day, end_day)
    StaffAppointFrame
      .where(acceptable_frame_start: start_day..end_day)
      .group("DATE_FORMAT(acceptable_frame_start, '%Y-%m-%d %T')")
      .count
  end
end
