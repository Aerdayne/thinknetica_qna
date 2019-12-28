class Api::V1::AnswersController < Api::V1::BaseController
  before_action :identify_question, only: %i[index create]
  before_action :identify_answer, only: %i[show update destroy]

  def index
    @answers = @question.answers
    authorize! :read, @answers

    render json: @answers
  end

  def show
    authorize! :read, @answer

    render json: @answer
  end

  def create
    @answer = @question.answers.new(answer_params)
    @answer.user = current_resource_owner
    authorize! :create, @answer

    @answer.save
    render json: @answer
  end

  def update
    authorize! :update, @answer

    @answer.update!(answer_params)
    render json: @answer
  end

  def destroy
    authorize! :destroy, @answer

    @answer.destroy
    render json: @answer
  end

  private

  def identify_answer
    @answer = Answer.find(params[:id])
  end

  def identify_question
    @question = Question.find(params[:question_id])
  end

  def answer_params
    params.require(:answer).permit(:body, links_attributes: [:id, :name, :url, :_destroy])
  end
end
