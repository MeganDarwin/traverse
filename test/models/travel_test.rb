require "test_helper"

class TravelTest < ActiveSupport::TestCase
  def setup
    @travel = travels(:one)
  end

  test "should be valid" do
    assert @travel.valid?
  end

  test "name should be present" do
    @travel.name = "     "
    assert_not @travel.valid?
  end

  test "should belong to a user" do
    assert_respond_to @travel, :user
  end

  test "should have many attached images" do
    assert_respond_to @travel, :images
  end

  test "should have many comments" do
    assert_respond_to @travel, :comments
  end

  test "should destroy associated comments" do
    assert_difference "Comment.count", -1 do
      @travel.destroy
    end
  end

  test "start_date should be before end_date" do
    @travel.start_date = Date.today
    @travel.end_date = Date.yesterday
    assert_not @travel.valid?
  end

  test "default scope should order by created_at desc" do
    assert_equal travels(:two), Travel.first
  end

  test "for_user scope should return travels for the given user" do
    user = users(:one)
    assert_equal 1, Travel.for_user(user).count
    assert_equal travels(:one), Travel.for_user(user).first
  end

  test "dates_traveled should return correct date range" do
    @travel.start_date = Date.new(2023, 1, 1)
    @travel.end_date = Date.new(2023, 1, 10)
    assert_equal "Jan 01, 2023 - Jan 10, 2023", @travel.dates_traveled
  end

  test "dates_traveled should handle missing start_date" do
    @travel.start_date = nil
    @travel.end_date = Date.new(2023, 1, 10)
    assert_equal "Jan 10, 2023", @travel.dates_traveled
  end

  test "dates_traveled should handle missing end_date" do
    @travel.start_date = Date.new(2023, 1, 1)
    @travel.end_date = nil
    assert_equal "Jan 01, 2023", @travel.dates_traveled
  end

  test "dates_traveled should handle missing both dates" do
    @travel.start_date = nil
    @travel.end_date = nil
    assert_equal "Not Provided", @travel.dates_traveled
  end
end
