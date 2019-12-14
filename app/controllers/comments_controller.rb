class CommentsController < ApplicationController
  before_action :authenticate_user!

  expose :comment
  expose :resource,
    model: 
      -> do
        if params[:question_id]
          Question
        else
          Answer
        end
      end,
    id: -> { params[:question_id] || params[:answer_id] }

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

  def send_json
    render json: { resource_id: resource.id, comment: @comment, email: @comment.user.email }
  end
end
