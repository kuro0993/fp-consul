require "test_helper"

class AppointServiceTest < ActiveSupport::TestCase
  test "受付可能日" do
    list = AppointService.get_can_appoint_dates(2022, 8)
    hash = {}
    list.each do |a| 
      hash[a[:start_time]] = a
    end
    # 期待値
    expects =  {
      "2022-08-01"=> 12,
      "2022-08-02"=> 14,
      "2022-08-03"=> 16,
      "2022-08-04"=> 16, 
      "2022-08-05"=> 16,
    }
    expects.map do |k, v|
      assert_equal v, hash[k][:remaining_count], k
    end
  end
  test "日別受付可能枠時間" do
    date = Time.zone.local(2022, 8, 1)
    list = AppointService.get_can_appoint_times(date)
    hash = {}
    list.each do |a| 
      hash[a[:start_time]] = a
    end
    # 期待値
    expects =  {
      "2022-08-01 10:30:00"=> nil,
      "2022-08-01 11:00:00"=> 1,
      "2022-08-01 11:30:00"=> 1,
      "2022-08-01 12:00:00"=> 0,
      "2022-08-01 12:30:00"=> 2,
    }
    expects.map do |k, v|
      if v.nil?
        assert_nil hash[k]
        next
      end
      assert_equal v, hash[k][:remaining_count], k
    end
  end
  test "日別受付可能枠時間2" do
    date = Time.zone.local(2022, 10, 1)
    list = AppointService.get_can_appoint_times(date)
    hash = {}
    list.each do |a| 
      hash[a[:start_time]] = a
    end
    # 期待値
    expects =  {
      "2022-10-01 10:30:00"=> nil,
      "2022-10-01 11:00:00"=> nil,
      "2022-10-01 11:30:00"=> nil,
      "2022-10-01 12:00:00"=> nil,
      "2022-10-01 12:30:00"=> nil,
    }
    expects.map do |k, v|
      if v.nil?
        assert_nil hash[k]
        next
      end
      assert_equal v, hash[k][:remaining_count], k
    end
  end
end