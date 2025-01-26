class CommentsController < ApplicationController
  before_action :set_commentable
  before_action :set_comment, only: [ :edit, :update, :destroy ]
  before_action :authorize_edit!, only: [ :edit, :update ]
  before_action :authorize_delete!, only: [ :destroy ]

  def create
    @comment = @commentable.comments.new(comment_params)

    respond_to do |format|
      if @comment.save
        format.html { redirect_to @commentable, notice: "Comment was successfully created." }
        format.turbo_stream
      else
        format.html { render :new, status: :unprocessable_entity }
        format.turbo_stream
      end
    end
  end

  def edit
    respond_to do |format|
      puts "*" * 100
      puts @comment.commentable
      puts "*" * 100

      format.turbo_stream { render turbo_stream: turbo_stream.replace("comment_#{@comment.id}", partial: "comments/form", locals: { comment: @comment, commentable: @comment.commentable }) }
      format.html
    end
  end

  def update
    respond_to do |format|
      if @comment.update(comment_params)
        format.html { redirect_to @commentable, notice: "Comment was successfully updated." }
        format.turbo_stream {
          render turbo_stream: turbo_stream.replace("comment_#{@comment.id}", partial: "comments/comment", locals: {
            comment: @comment,
            edit_path: polymorphic_path([ :edit, @comment.commentable, @comment ]),
            delete_path: polymorphic_path([ @comment.commentable, @comment ])
          })
        }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.turbo_stream { render turbo_stream: turbo_stream.replace("comment_#{@comment.id}", partial: "comments/form", locals: { comment: @comment }) }
      end
    end
  end

  def destroy
    @comment.destroy!

    respond_to do |format|
      format.html { redirect_to @commentable, status: :see_other, notice: "Comment was successfully destroyed." }
      format.turbo_stream { render turbo_stream: turbo_stream.remove("comment_#{@comment.id}") }
    end
  end

  private

  def set_commentable
    if params[:travel_id].present?
      @commentable = Travel.find(params[:travel_id])
    else
      redirect_back(fallback_location: root_path, alert: "Commentable not found.")
    end
  rescue ActiveRecord::RecordNotFound
    redirect_back(fallback_location: root_path, alert: "Commentable not found.")
  end

  def set_comment
    @comment = Comment.find(params[:id])
  end

  def authorize_edit!
    unless @comment.user == current_user
      redirect_back(fallback_location: root_path, alert: "You are not authorized to edit this comment.")
    end
  end

  def authorize_delete!
    unless @comment.user == current_user || @commentable.user == current_user
      redirect_back(fallback_location: root_path, alert: "You are not authorized to delete this comment.")
    end
  end

  def comment_params
    params.require(:comment).permit(:body, :commentable_id, :commentable_type).merge(user: current_user)
  end
end
