class CommentsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @comment = comments(:one)
    @user = users(:one)
    @travel = travels(:one)
    sign_in_user
  end
  test "should create comment" do
    assert_difference("Comment.count") do
      post travel_comments_url(@travel), params: { comment: { body: "New comment" } }
    end

    assert_redirected_to travel_url(@travel)
  end
  test "should get edit" do
    get edit_comment_url(@comment, travel_id: @travel.id)
    assert_response :success
  end

  test "should update comment" do
    patch comment_url(@comment, travel_id: @travel.id), params: { comment: { body: "Updated comment" } }
    assert_redirected_to travel_url(@comment.commentable)
  end

  test "should destroy comment" do
    assert_difference("Comment.count", -1) do
      delete comment_url(@comment, travel_id: @travel.id)
    end
    assert_redirected_to travel_url(@comment.commentable)
  end
end
