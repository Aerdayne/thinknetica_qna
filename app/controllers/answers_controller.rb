class AnswersController < ApplicationController
  include Voted

  before_action :authenticate_user!, except: %i[show]

  expose :question, id: -> { params[:question_id] }
  expose :answer, scope: -> { Answer.with_attached_files }
  expose :answers, -> { Answer.all }

  after_action :publish_answer, only: [:create]

  authorize_resource

  def create
    @answer = question.answers.new(answer_params)
    @answer.user = current_user
    @answer.save

    if @answer.persisted?
      @answer.notify_subscribers
      flash.now[:notice] = 'Your answer has been successfully created.'
    else
      flash.now[:alert] = 'Your answer has not been created.'
    end
  end

  def update
    authorize! :update, answer

    answer.update(answer_params)
    @question = answer.question
  end

  def destroy
    authorize! :destroy, answer

    answer.destroy
    flash[:notice] = 'Your answer has been successfully removed'
  end

  def set_best
    authorize! :set_best, answer

    @question = answer.question
    answer.set_best
    flash[:notice] = 'You have marked the best answer to your question'
  end

  private

  def answer_params
    params.require(:answer).permit(:body, files: [], links_attributes: [:id, :name, :url, :_destroy])
  end

  def publish_answer
    return if @answer.errors.any?

    ActionCable.server.broadcast(
      "question/#{@answer.question_id}/answers",
      answer: @answer,
      question_author_id: @answer.question.user_id
    )
  end
end
