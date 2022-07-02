class Appoint < ApplicationRecord
  belongs_to :customer
  belongs_to :staff

  validates :start_datetime, presence: true
  validates :end_datetime, presence: true
  validates :consultation_content, presence: false
  validates :customer, presence: true
  validates :staff, presence: true

  validates :end_datetime, comparison: { greater_than: :start_datetime }
  validate :check_frame_time, :check_staff_appoint_duplicate, :check_customer_appoint_duplicate, :check_biz_time
  
  # TODO: 予約は翌日以降のみ

  # 予約枠時間チェック
  def check_frame_time
    if (end_datetime - start_datetime) / 60 != Constants::APPOINT_FRAME_MINUTES then
      errors.add("予約枠は#{Constants::APPOINT_FRAME_MINUTES}分である必要があります")
    end
  end

  # スタッフ予約重複チェック
  def check_staff_appoint_duplicate
    hasApo = Appoint.where(staff: staff)
    if hasApo.count.zero? then
      return
    end
    # TODO: staff.appointの絞り込み or SQL化?
    hasApo.each do |ap|
      # 予約開始時間が 既存の面談予定開始時間 ~ 既存の面談予定終了時間 の間のときは重複
      if start_datetime >= ap.start_datetime && start_datetime <= ap.end_datetime then
        errors.add('別の相談予定があるため予約できません(staff)')
        return
      end
      # 予約終了時間が 既存の面談予定開始時間 ~ 既存の面談予定終了時間 の間のときは重複
      if end_datetime >= ap.start_datetime && end_datetime <= ap.end_datetime then
        errors.add('別の相談予定があるため予約できません(staff)')
        return
      end
    end
  end

  # 顧客予約重複チェック
  def check_customer_appoint_duplicate
    hasApo = Appoint.where(customer: customer)
    if hasApo.count.zero? then
      return
    end
    # TODO: customer.appointの絞り込み or SQL化?
    hasApo.each do |ap|
      # 予約開始時間が 既存の面談予定開始時間 ~ 既存の面談予定終了時間 の間のときは重複
      if start_datetime >= ap.start_datetime && start_datetime <= ap.end_datetime then
        errors.add('別の相談予定があるため予約できません(customer)')
        return
      end
      # 予約終了時間が 既存の面談予定開始時間 ~ 既存の面談予定終了時間 の間のときは重複
      if end_datetime >= ap.start_datetime && end_datetime <= ap.end_datetime then
        errors.add('別の相談予定があるため予約できません(customer)')
        return
      end
    end
  end

  # 営業時間内チェック
  def check_biz_time
    apo_weekday = Time.zone.parse(start_datetime.to_s).wday
    biz_time = BusinessTimeMaster.find_by(weekday_id: apo_weekday)

    if !(BusinessTimeMaster.check_biz_time(start_datetime) \
      && BusinessTimeMaster.check_biz_time(end_datetime)) then
      errors.add('営業時間外のため予約できません')
    end
  end

  # 予約 日別集計
  def self.aggregate_daily(start_day, end_day)
    Appoint
      .where(start_datetime: start_day..end_day)
      .group("DATE_FORMAT(start_datetime, '%Y-%m-%d')")
      .count
  end

  # 予約 時間別集計
  def self.aggregate_hourly(start_day, end_day)
    Appoint
      .where(start_datetime: start_day..end_day)
      .group("DATE_FORMAT(start_datetime, '%Y-%m-%d %T')")
      .count
  end
end