class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]

  expose :question, scope: -> { Question.with_attached_files }
  expose :questions, -> { Question.all }
  expose :answers, -> { question.answers }

  def show
    @answer = Answer.new
    @answer.links.new
  end

  def new
    @question = Question.new
    @question.links.new
  end

  def create
    @question = current_user.questions.new(question_params)

    if @question.save
      redirect_to @question, notice: 'Your question has been successfully created.'
    else
      render :new
    end
  end

  def update
    question.update(question_params) if current_user.author_of?(question)
    @question = question
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
    params.require(:question).permit(:body, :title, files: [], links_attributes: [:name, :url])
  end
end
