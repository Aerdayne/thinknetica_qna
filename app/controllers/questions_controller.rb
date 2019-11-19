class QuestionsController < ApplicationController
  expose :question
  expose :questions, -> { Question.all }

  def create
    @question = Question.new(question_params)

    if @question.save
      redirect_to @question
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
    question.destroy
    redirect_to questions_path
  end

  private

  def question_params
    params.require(:question).permit(:body, :title)
  end
end
