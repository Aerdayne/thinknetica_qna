class DailyDigestMailer < ApplicationMailer
  def digest(user, questions_ids)
    @questions = Question.where(id: questions_ids)
    mail to: user.email
  end
end