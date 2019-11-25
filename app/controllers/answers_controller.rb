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
      format.js do
        if @answer.persisted?
          flash.now[:notice] = 'Your answer has been successfully created.'
        else
          flash.now[:alert] = 'Your answer has not been created.'
        end
      end
    end
  end

  def update
    answer.update(answer_params)

    respond_to do |format|
      format.js do
        @question = answer.question
      end
    end
  end

  def destroy
    current_user.answers.find_by(id: answer.id)&.destroy if current_user&.author_of?(answer)

    respond_to do |format|
      format.js do
        @answer = answer
        if current_user.author_of?(@answer)
          flash[:notice] = 'Your answer has been successfully removed'
        else
          flash[:alert] = 'You are not permitted to delete others\' answers'
        end
      end
    end
  end

  def set_best
    answer.set_best

    respond_to do |format|
      format.js do
        @question = answer.question
      end
    end
  end

  private

  def answer_params
    params.require(:answer).permit(:body)
  end
end
