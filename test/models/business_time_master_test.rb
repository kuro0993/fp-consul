require "test_helper"

class BusinessTimeMasterTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  test "平日" do
    from = Time.zone.local(2022,7,4)
    to = Time.zone.local(2022,7,8)
    
    (from.to_date..from.to_date).each do |d|
      biz_time = BusinessTimeMaster.get_biz_time(d.to_time)
      assert_equal d.to_time.wday, biz_time.weekday_id
      assert_equal '10:00', biz_time.start_time.strftime('%H:%M')
      assert_equal '18:00', biz_time.end_time.strftime('%H:%M')  
    end
  end
  test "土曜日" do
    date = Time.zone.local(2022,7,9)
    biz_time = BusinessTimeMaster.get_biz_time(date)
    assert_equal date.to_time.wday, biz_time.weekday_id
    assert_equal '11:00', biz_time.start_time.strftime('%H:%M')
    assert_equal '15:00', biz_time.end_time.strftime('%H:%M')  
  end
  test "日曜日" do
    date = Time.zone.local(2022,7,10)
    biz_time = BusinessTimeMaster.get_biz_time(date)
    assert_equal date.to_time.wday, biz_time.weekday_id
    assert_nil biz_time.start_time
    assert_nil biz_time.end_time
  end
end
