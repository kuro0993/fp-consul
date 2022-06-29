require "test_helper"

class AppointTest < ActiveSupport::TestCase
  # 正常パターン
  test "正常パターン" do
    apo1 = Appoint.new do |ap|
      ap.staff = Staff.find(1)
      ap.customer = Customer.find(1)
      ap.start_datetime = Time.zone.local(2022, 7, 1, 10, 0)
      ap.end_datetime = Time.zone.local(2022, 7, 1, 10, 30)
    end
    assert apo1.save
    apo2 = Appoint.new do |ap|
      ap.staff = Staff.find(1)
      ap.customer = Customer.find(1)
      ap.start_datetime = Time.zone.local(2022, 7, 2, 14, 0)
      ap.end_datetime = Time.zone.local(2022, 7, 2, 14, 30)
    end
    assert apo2.save
  end

  # 異常パターン
  test "営業時間外" do
    staff = Staff.find(1)
    customer = Customer.find(1)
    before_start1 = Appoint.new do |ap|
      ap.staff = staff
      ap.customer = customer
      ap.start_datetime = Time.zone.local(2022, 7, 1, 9, 30)
      ap.end_datetime = Time.zone.local(2022, 7, 1, 10, 0)
    end
    assert_not before_start1.save

    before_start2 = Appoint.new do |ap|
      ap.staff = staff
      ap.customer = customer
      ap.start_datetime = Time.zone.local(2022, 7, 1, 9, 30)
      ap.end_datetime = Time.zone.local(2022, 7, 1, 10, 30)
    end
    assert_not before_start2.save

    after_end1 = Appoint.new do |ap|
      ap.staff = staff
      ap.customer = customer
      ap.start_datetime = Time.zone.local(2022, 7, 1, 18, 0)
      ap.end_datetime = Time.zone.local(2022, 7, 1, 18, 30)
    end
    assert_not after_end1.save

    after_end2 = Appoint.new do |ap|
      ap.staff = staff
      ap.customer = customer
      ap.start_datetime = Time.zone.local(2022, 7, 1, 17, 30)
      ap.end_datetime = Time.zone.local(2022, 7, 1, 18, 30)
    end
    assert_not after_end2.save
  end

  test "顧客の予約重複" do 
    customer = Customer.find(1)
    s = Time.zone.local(2022, 7, 1, 10, 30)
    e = Time.zone.local(2022, 7, 1, 11, 0)
    apo1 = Appoint.new do |ap|
      ap.staff = Staff.find(1)
      ap.customer = customer
      ap.start_datetime = s
      ap.end_datetime = e
    end
    apo2 = Appoint.new do |ap|
      ap.staff = Staff.find(2)
      ap.customer = customer
      ap.start_datetime = s
      ap.end_datetime = e
    end
    apo1.save

    assert_not apo2.save
  end
  test "FPの予約重複" do 
    s = Time.zone.local(2022, 7, 1, 11, 30)
    e = Time.zone.local(2022, 7, 1, 12, 0)
    staff = Staff.find(1)
    apo1 = Appoint.new do |ap|
      ap.staff = staff
      ap.customer = Customer.find(1)
      ap.start_datetime = s
      ap.end_datetime = e
    end
    apo2 = Appoint.new do |ap|
      ap.staff = staff
      ap.customer = Customer.find(2)
      ap.start_datetime = s
      ap.end_datetime = e
    end

    apo1.save
    assert_not apo2.save
  end

  ##############
  test "予約時間枠が設定値と一致しない" do
    ap1 = Appoint.new do |ap|
      ap.start_datetime = Time.zone.local(2022,7,1,10,0)
      ap.end_datetime = Time.zone.local(2022,7,1,10,10)
    end
    ap1.check_frame_time
    assert_equal 1, ap1.errors.count

    ap2 = Appoint.new do |ap|
      ap.start_datetime = Time.zone.local(2022,7,1,10,0)
      ap.end_datetime = Time.zone.local(2022,7,1,10,40)
    end
    ap2.check_frame_time
    assert_equal 1, ap2.errors.count
  end

  test "予約 日別集計" do
    s = Time.zone.local(2022,8,1)
    e = Time.zone.local(2022,8,31)
    res = Appoint.aggregate_daily(s, e)
    assert_equal 4, res['2022-08-01']
  end
  test "予約 時間別集計" do
    s = BusinessTimeMaster.start_of_biz(Time.zone.local(2022,8,1))
    e = BusinessTimeMaster.end_of_biz(Time.zone.local(2022,8,1))
    res = Appoint.aggregate_hourly(s, e)
    assert_nil res['2022-08-01 10:00:00']
    assert_equal 1, res['2022-08-01 11:00:00']
    assert_equal 1, res['2022-08-01 11:30:00']
    assert_equal 2, res['2022-08-01 12:00:00']
    assert_nil res['2022-08-01 12:30:00']
  end

end
