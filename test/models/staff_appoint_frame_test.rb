require "test_helper"

class StaffAppointFrameTest < ActiveSupport::TestCase
  # 正常パターン
  test "正常パターン" do
    frame1 = StaffAppointFrame.new do |f|
      f.acceptable_frame_start = Time.zone.local(2022, 7, 1, 10, 0)
      f.acceptable_frame_end = Time.zone.local(2022, 7, 1, 10, 30)
      f.staff = Staff.find(1)
    end
    assert frame1.save
    frame2 = StaffAppointFrame.new do |f|
      f.acceptable_frame_start = Time.zone.local(2022, 7, 1, 17, 30)
      f.acceptable_frame_end = Time.zone.local(2022, 7, 1, 18, 0)
      f.staff = Staff.find(1)
    end
    assert frame2.save
  end
  test "予約可能枠 日別集計" do
    s = Time.zone.local(2022,8,1)
    e = Time.zone.local(2022,8,31)
    res = StaffAppointFrame.aggregate_daily(s, e)
    res.map do |k, v|
      assert_equal 16, v
    end
  end
  test "予約可能枠 時間別集計" do
    s = BusinessTimeMaster.start_of_biz(Time.zone.local(2022,8,1))
    e = BusinessTimeMaster.end_of_biz(Time.zone.local(2022,8,1))
    res = StaffAppointFrame.aggregate_hourly(s, e)
    res.map do |k, v|
      assert_equal 2, v
    end
  end

  # 異常パターン
  test "営業時間外" do
    staff = Staff.find(1)
    before_start1 = StaffAppointFrame.new do |f|
      f.acceptable_frame_start = Time.zone.local(2022, 7, 1, 9, 30)
      f.acceptable_frame_end = Time.zone.local(2022, 7, 1, 10, 0)
      f.staff = staff
    end
    assert_not before_start1.save

    before_start2= StaffAppointFrame.new do |f|
      f.acceptable_frame_start = Time.zone.local(2022, 7, 1, 9, 30)
      f.acceptable_frame_end = Time.zone.local(2022, 7, 1, 10, 30)
      f.staff = staff
    end
    assert_not before_start2.save

    after_end1 = StaffAppointFrame.new do |f|
      f.acceptable_frame_start = Time.zone.local(2022, 7, 1, 18, 0)
      f.acceptable_frame_end = Time.zone.local(2022, 7, 1, 18, 30)
      f.staff = staff
    end
    assert_not after_end1.save

    after_end1 = StaffAppointFrame.new do |f|
      f.acceptable_frame_start = Time.zone.local(2022, 7, 1, 17, 30)
      f.acceptable_frame_end = Time.zone.local(2022, 7, 1, 18, 30)
      f.staff = staff
    end
    assert_not after_end1.save
  end
  test "重複" do
    frame1 = StaffAppointFrame.new do |f|
      f.acceptable_frame_start = Time.zone.local(2022, 7, 1, 10, 0)
      f.acceptable_frame_end = Time.zone.local(2022, 7, 1, 10, 30)
      f.staff = Staff.find(1)
    end
    frame2 = frame1.deep_dup
    frame1.save
    assert_not frame2.save
  end
end
