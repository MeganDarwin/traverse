require "test_helper"

class CommentTest < ActiveSupport::TestCase
  def setup
    @comment = comments(:one)
  end

  test "should be valid" do
    assert @comment.valid?
  end

  test "body should be present" do
    @comment.body = "     "
    assert_not @comment.valid?
  end

  test "body should not be too long" do
    @comment.body = "a" * 1001
    assert_not @comment.valid?
  end

  test "should belong to a user" do
    assert_respond_to @comment, :user
  end

  test "should belong to a commentable" do
    assert_respond_to @comment, :commentable
  end

  test "default scope should order by created_at desc" do
    assert_equal comments(:two), Comment.first
  end
end
