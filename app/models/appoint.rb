class Appoint < ApplicationRecord
  belongs_to :customer
  belongs_to :staff

  validates :start_datetime, presence: true
  validates :end_datetime, presence: true
  validates :consultation_content, presence: false
  validates :customer, presence: true
  validates :staff, presence: true

  validates :end_datetime, comparison: { greater_than: :start_datetime }
  after_validation :after_validate

  # TODO: 予約は翌日以降のみ

  def after_validate
    # NOTE: 単項目チェックはバリデーションヘルパーでチェック済みのためそのままリターン
    return if start_datetime.nil? || end_datetime.nil? || staff.nil? || customer.nil?

    check_frame_time
    check_staff_appoint_duplicate
    check_customer_appoint_duplicate
    check_biz_time
  end

  # 予約枠時間チェック
  def check_frame_time
    if start_datetime.nil? \
       || end_datetime.nil? \
       || (end_datetime - start_datetime) / 60 != Constants::APPOINT_FRAME_MINUTES
      errors.add(:base, "予約枠は#{Constants::APPOINT_FRAME_MINUTES}分である必要があります")
    end
  end

  # スタッフ予約重複チェック
  def check_staff_appoint_duplicate
    has_apo = Appoint.where(staff: staff)
    return if has_apo.count.zero?

    # TODO: staff.appointの絞り込み or SQL化?
    has_apo.each do |ap|
      # 予約開始時間が 既存の面談予定開始時間 ~ 既存の面談予定終了時間 の間のときは重複
      if start_datetime >= ap.start_datetime && start_datetime < ap.end_datetime
        errors.add(:base, '別の相談予定があるため予約できません(staff)')
        return false
      end
      # 予約終了時間が 既存の面談予定開始時間 ~ 既存の面談予定終了時間 の間のときは重複
      if end_datetime > ap.start_datetime && end_datetime <= ap.end_datetime
        errors.add(:base, '別の相談予定があるため予約できません(staff)')
        return false
      end
    end
  end

  # 顧客予約重複チェック
  def check_customer_appoint_duplicate
    has_apo = Appoint.where(customer: customer)
    return if has_apo.count.zero?

    # TODO: customer.appointの絞り込み or SQL化?
    has_apo.each do |ap|
      # 予約開始時間が 既存の面談予定開始時間 ~ 既存の面談予定終了時間 の間のときは重複
      if start_datetime >= ap.start_datetime && start_datetime < ap.end_datetime
        return errors.add(:base, '別の相談予定があるため予約できません(customer)')
      end
      # 予約終了時間が 既存の面談予定開始時間 ~ 既存の面談予定終了時間 の間のときは重複
      if end_datetime > ap.start_datetime && end_datetime <= ap.end_datetime
        return errors.add(:base, '別の相談予定があるため予約できません(customer)')
      end
    end
  end

  # 営業時間内チェック
  def check_biz_time
    unless BusinessTimeMaster.check_biz_time(start_datetime) \
      && BusinessTimeMaster.check_biz_time(end_datetime)
      errors.add(:base, '営業時間外のため予約できません')
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