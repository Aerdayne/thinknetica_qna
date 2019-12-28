class Api::V1::QuestionsController < Api::V1::BaseController
  before_action :identify_question, only: %i[show update destroy]

  def index
    @questions = Question.all
    authorize! :read, @questions

    render json: @questions
  end

  def show
    authorize! :read, @question

    render json: @question
  end

  def create
    @question = current_resource_owner.questions.new(question_params)
    authorize! :create, @question

    @question.save
    render json: @question
  end

  def update
    authorize! :update, @question

    @question.update!(question_params)
    render json: @question
  end

  def destroy
    authorize! :destroy, @question

    @question.destroy
    render json: @question
  end

  private

  def identify_question
    @question = Question.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:body, :title,
                                     links_attributes: [:id, :name, :url, :_destroy],
                                     reward_attributes: [:name, :file])
  end
end
