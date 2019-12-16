class CommentsController < ApplicationController
  before_action :authenticate_user!

  expose :comment
  expose :resource, model: lambda {
                             if params[:question_id]
                               Question
                             else
                               Answer
                             end
                           },
                    id: -> { params[:question_id] || params[:answer_id] }

  after_action :publish_comment, only: [:create]

  def create
    @comment = resource.comments.new(comment_params)
    @comment.user = current_user
    @comment.save
  end

  def destroy
    comment.destroy if current_user.author_of?(comment)
  end

  private

  def comment_params
    params.require(:comment).permit(:id, :content)
  end

  def publish_comment
    return if @comment.errors.any?

    question = if resource.is_a? Answer
                 resource.question
               else
                 resource
               end

    ActionCable.server.broadcast(
      "question/#{question.id}/comments",
      comment: @comment,
      resource_id: @comment.commentable_id,
      resource_type: @comment.commentable_type,
      user_email: @comment.user.email
    )
  end
end
