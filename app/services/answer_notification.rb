class AnswerNotification
  def send_notification(answer)
    form_notification(answer)
    @users.find_each(batch_size: 500) do |user|
      AnswerNotificationMailer.notify(user, @answer, @question).deliver_later
    end
  end

  private

  def form_notification(answer)
    @answer = answer
    @question = answer.question
    @users = User.joins(:subscriptions).where(subscriptions: { question_id: @question } ).where.not(id: @answer.user_id)
  end
end