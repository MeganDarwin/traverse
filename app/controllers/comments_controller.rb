class CommentsController < ApplicationController
  before_action :set_commentable
  before_action :set_comment, only: [ :edit, :update, :destroy ]
  before_action :authorize_edit!, only: [ :edit, :update ]
  before_action :authorize_delete!, only: [ :destroy ]

  def create
    @comment = @commentable.comments.new(comment_params)
    authorize @comment
    if @comment.save
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to @travel, notice: "Comment was successfully created." }
      end
    else
      respond_to do |format|
        format.html { render :new }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  def edit
    respond_to do |format|
      format.turbo_stream
      format.html
    end
  end

  def update
    if @comment.update(comment_params)
      respond_to do |format|
        format.html { redirect_to @comment.commentable, notice: "Comment was successfully updated." }
      end
    else
      respond_to do |format|
        format.html { render :edit }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    authorize @comment
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
