class AnswersController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]

  expose :question, id: -> { params[:question_id] }
  expose :answer
  expose :answers, -> { Answer.all }

  def create
    @answer = question.answers.new(answer_params)
    @answer.user = current_user

    if @answer.save
      redirect_to @answer.question, notice: 'Your answer has been successfully created.'
    else
      render 'questions/show'
    end
  end

  def update
    if answer.update(answer_params)
      redirect_to answer_path(answer)
    else
      render :edit
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
