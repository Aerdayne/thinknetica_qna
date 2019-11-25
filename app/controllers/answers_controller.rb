class AnswersController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]

  expose :question, id: -> { params[:question_id] }
  expose :answer
  expose :answers, -> { Answer.all }

  def create
    @answer = question.answers.new(answer_params)
    @answer.user = current_user
    @answer.save

    respond_to do |format|
      format.js { flash.now[:notice] = 'Your answer has been successfully created.' }
    end
  end

  def update
    answer.update(answer_params)

    respond_to do |format|
      format.js do
        @question = answer.question
        flash.now[:notice] = 'Your answer has been successfully edited.'
      end
    end
  end

  def destroy
    if current_user.author_of?(answer)
      answer.destroy
      flash[:notice] = 'Your answer has been successfully removed'
    else
      flash[:alert] = 'You are not permitted to delete others\' answers'
    end
    redirect_to question_path(answer.question)
  end

  private

  def answer_params
    params.require(:answer).permit(:body)
  end
end
