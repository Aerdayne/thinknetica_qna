class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]

  expose :question
  expose :questions, -> { Question.all }
  expose :answers, -> { question.answers }

  def create
    @question = current_user.questions.new(question_params)

    if @question.save
      redirect_to @question, notice: 'Your question has been successfully created.'
    else
      render :new
    end
  end

  def update
    if question.update(question_params)
      redirect_to question_path(question)
    else
      render :edit
    end
  end

  def destroy
    if current_user.author_of?(question)
      question.destroy
      redirect_to questions_path, notice: 'Your question has been successfully deleted'
    else
      redirect_to question, alert: 'You are not permitted to delete others\' questions'
    end
  end

  private

  def question_params
    params.require(:question).permit(:body, :title)
  end
end
