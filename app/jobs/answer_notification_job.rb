class AnswerNotificationJob < ApplicationJob
  queue_as :default

  def perform(answer)
    AnswerNotification.new.send_notification(answer)
  end
end
