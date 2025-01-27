require "test_helper"

class UserTest < ActiveSupport::TestCase
  def setup
    @user = users(:one)
    @other_user = users(:two)
  end

  test "should be valid" do
    assert @user.valid?
  end

  test "email should be present" do
    @user.email = "     "
    assert_not @user.valid?
  end

  test "email should be unique" do
    duplicate_user = @user.dup
    duplicate_user.email = @user.email.upcase
    @user.save
    assert_not duplicate_user.valid?
  end

  test "password should be present" do
    @user.password = @user.password_confirmation = " " * 6
    assert_not @user.valid?
  end

  test "password should have a minimum length" do
    @user.password = @user.password_confirmation = "a" * 5
    assert_not @user.valid?
  end

  test "should have many comments" do
    assert_respond_to @user, :comments
  end

  test "should have many travels" do
    assert_respond_to @user, :travels
  end

  test "should destroy associated travels" do
    assert_difference "Travel.count", -1 do
      @user.destroy
    end
  end

  test "full_name should return the correct full name" do
    assert_equal "#{@user.first_name} #{@user.last_name}", @user.full_name
  end
end
