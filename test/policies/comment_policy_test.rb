require "test_helper"

class CommentPolicyTest < ActiveSupport::TestCase
  def setup
    @user = users(:one)
    @other_user = users(:two)
    @comment = comments(:one)
    @other_comment = comments(:two)
  end

  def test_scope
    assert_equal CommentPolicy::Scope.new(@user, Comment).resolve, Comment.all
  end

  def test_show
    assert CommentPolicy.new(@user, @comment).show?
    assert CommentPolicy.new(@other_user, @comment).show?
    assert_not CommentPolicy.new(nil, @comment).show?
  end

  def test_create
    assert CommentPolicy.new(@user, Comment.new).create?
    assert_not CommentPolicy.new(nil, Comment.new).create?
  end

  def test_update
    assert CommentPolicy.new(@user, @comment).update?
    assert_not CommentPolicy.new(@other_user, @comment).update?
    assert_not CommentPolicy.new(@user, @other_comment).update?
  end

  def test_destroy
    assert CommentPolicy.new(@user, @comment).destroy?
    assert_not CommentPolicy.new(@other_user, @comment).destroy?
    assert_not CommentPolicy.new(@user, @other_comment).destroy?
  end
end
