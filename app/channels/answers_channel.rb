class AnswersChannel < ApplicationCable::Channel
  def subscribed; end

  def unsubscribed; end

  def follow(data)
    stream_from "question#{data['id']}"
  end
end
