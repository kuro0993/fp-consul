require "test_helper"

class CustomerTest < ActiveSupport::TestCase
  def setup
    @customer = Customer.new(
                        first_name: "太郎",
                        last_name: "田中",
                        first_name_kana: "タロウ",
                        last_name_kana: "タナカ",
                        email: "tanaka-taro@example.com",
                        password: "Password1",
                        password_confirmation: "Password1"\
      )
  end
  test "should be valid" do
    assert @customer.valid?
  end
  test "first_name should be present" do
    @customer.first_name = "     "
    assert_not @customer.valid?
  end
  test "email should be present" do
    @customer.email = "     "
    assert_not @customer.valid?
  end
  test "first_name should not be too long" do
    @customer.first_name = "a" * 51
    assert_not @customer.valid?
  end
  test "email should not be too long" do
    @customer.email = "a" * 244 + "@example.com"
    assert_not @customer.valid?
  end
  test "email addresses should be unique" do
    duplicate_user = @customer.dup
    duplicate_user.email = @customer.email.upcase
    @customer.save
    assert_not duplicate_user.valid?
  end
  test "email addresses should be saved as lower-case" do
    mixed_case_email = "Foo@ExAMPle.CoM"
    @customer.email = mixed_case_email
    @customer.save
    assert_equal mixed_case_email.downcase, @customer.reload.email
  end
  test "password should be present (nonblank)" do
    @customer.password = @customer.password_confirmation = " " * 6
    assert_not @customer.valid?
  end

  test "password should have a minimum length" do
    @customer.password = @customer.password_confirmation = "a" * 5
    assert_not @customer.valid?
  end
end
