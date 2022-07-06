class StaffAppointFrame < ApplicationRecord
  belongs_to :staff

  validates :acceptable_frame_start, presence: true
  validates :acceptable_frame_end, presence: true
  validates :staff, presence: true, uniqueness: { scope: [:acceptable_frame_start, :acceptable_frame_end] }

  validates :acceptable_frame_end, comparison: { greater_than: :acceptable_frame_start }
  after_validation :check_frame_time

  def check_frame_time
    if (acceptable_frame_end - acceptable_frame_start) / 60 != Constants::APPOINT_FRAME_MINUTES
      errors.add(:base, '受付予約枠は1枠30分で設定する必要があります')
    end
    unless BusinessTimeMaster.check_biz_time(acceptable_frame_start) \
      && BusinessTimeMaster.check_biz_time(acceptable_frame_end)
      errors.add(:base, '受付予約枠が営業時間外です')
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

  # 予約可能スタッフ一覧
  def self.can_appoint_staffs(start_time, end_time)
    # TODO: N+1対策要検討
    # 予約可能枠の時間内に start_time, end_time が収まっている社員を取得
    staffs = StaffAppointFrame.select(:staff_id)
                              .where(acceptable_frame_start: ..start_time)
                              .where(acceptable_frame_end: end_time..)
                              .distinct(:staff_id)
    staff_list = []
    staffs.each do |s|
      # 予約済みのレコードがある場合は、除外
      appoints = s.staff.appoint
                  .where(start_datetime: start_time..)
                  .where(end_datetime: ..end_time)
      if appoints.count.zero?
        staff_list.push s.staff
      end
    end
    staff_list
  end
end
