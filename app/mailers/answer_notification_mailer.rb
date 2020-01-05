class AnswerNotificationMailer < ApplicationMailer
  def notify(user, answer, question)
    @answer = answer
    @question = question
    mail to: user.email, subject: 'Notification'
  end
end