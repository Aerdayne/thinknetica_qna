class QuestionsController < ApplicationController
  include Voted

  before_action :authenticate_user!, except: %i[index show]

  expose :question, scope: -> { Question.with_attached_files }
  expose :questions, -> { Question.all }
  expose :answers, -> { question.answers }

  after_action :publish_question, only: [:create]

  authorize_resource

  def show
    @answer = Answer.new
    @answer.links.new
  end

  def new
    @question = Question.new
    @question.links.new
    @reward = Reward.new
    @question.reward = @reward
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
    authorize! :update, question

    question.update(question_params)
    @question = question
  end

  def destroy
    authorize! :destroy, question

    question.destroy
    redirect_to questions_path, notice: 'Your question has been successfully deleted'
  end

  private

  def question_params
    params.require(:question).permit(:body, :title,
                                     files: [],
                                     links_attributes: [:id, :name, :url, :_destroy],
                                     reward_attributes: [:name, :file])
  end

  def publish_question
    return if @question.errors.any?

    ActionCable.server.broadcast(
      'questions',
      partial: 'questions/question',
      locals: { question: @question }
    )
  end
end
