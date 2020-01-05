class SubscriptionsController < ApplicationController
  before_action :authenticate_user!

  expose :question, id: -> { params[:question_id] }
  expose :subscription

  def create
    authorize! :subscribe, question

    question.subscribe(current_user)
  end

  def destroy
    authorize! :unsubscribe, question

    question.unsubscribe(current_user)
  end

  private

  def subscription_params
    params.require(:subscription).permit(:id)
  end
end
