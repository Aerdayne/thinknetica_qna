class AnswersController < ApplicationController
  include Voted

  before_action :authenticate_user!, except: %i[show]

  expose :question, id: -> { params[:question_id] }
  expose :answer, scope: -> { Answer.with_attached_files }
  expose :answers, -> { Answer.all }

  def create
    @answer = question.answers.new(answer_params)
    @answer.user = current_user
    @answer.save

    if @answer.persisted?
      flash.now[:notice] = 'Your answer has been successfully created.'
    else
      flash.now[:alert] = 'Your answer has not been created.'
    end
  end

  def update
    answer.update(answer_params) if current_user.author_of?(answer)
    @question = answer.question
  end

  def destroy
    if current_user.author_of?(answer)
      answer.destroy
      flash[:notice] = 'Your answer has been successfully removed'
    else
      flash[:alert] = 'You are not permitted to delete others\' answers'
    end
  end

  def set_best
    @question = answer.question
    if current_user.author_of?(@question)
      answer.set_best
      flash[:notice] = 'You have marked the best answer to your question'
    else
      flash[:alert] = 'You are not permitted to mark answers to others\' questions'
    end
  end

  private

  def answer_params
    params.require(:answer).permit(:body, files: [], links_attributes: [:id, :name, :url, :_destroy])
  end
end
