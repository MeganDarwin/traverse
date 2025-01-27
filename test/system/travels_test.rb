require "application_system_test_case"

class TravelsTest < ApplicationSystemTestCase
  setup do
    @travel = travels(:one)
  end

  test "visiting the index" do
    visit travels_url
    assert_selector "h1", text: "Travels"
  end

  test "should create travel" do
    visit travels_url
    click_on "New travel"

    fill_in "End date", with: @travel.end_date
    check "Favorite" if @travel.favorite
    fill_in "Name", with: @travel.name
    fill_in "Start date", with: @travel.start_date
    fill_in "User", with: @travel.user_id
    click_on "Create Travel"

    assert_text "Travel was successfully created"
    click_on "Back"
  end

  test "should update Travel" do
    visit travel_url(@travel)
    click_on "Edit this travel", match: :first

    fill_in "End date", with: @travel.end_date
    check "Favorite" if @travel.favorite
    fill_in "Name", with: @travel.name
    fill_in "Start date", with: @travel.start_date
    fill_in "User", with: @travel.user_id
    click_on "Update Travel"

    assert_text "Travel was successfully updated"
    click_on "Back"
  end

  test "should destroy Travel" do
    visit travel_url(@travel)
    click_on "Destroy this travel", match: :first

    assert_text "Travel was successfully destroyed"
  end
end
