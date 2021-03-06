class CommentsChannel < ApplicationCable::Channel
  def subscribed; end

  def unsubscribed; end

  def follow(data)
    stream_from "question/#{data['id']}/comments"
  end
end
