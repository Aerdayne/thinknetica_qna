module Voted
  extend ActiveSupport::Concern

  included do
    before_action :authenticate_user!
    before_action :set_votes, only: [:upvote, :downvote]
    before_action :set_resource, only: [:upvote, :downvote]
  end

  def upvote
    return head :forbidden if current_user.author_of?(@resource)

    vote = @votes.find_by(votable: @resource)
    @resource.unvote(current_user)
    @resource.upvote(current_user) unless vote
    send_json
  end

  def downvote
    return head :forbidden if current_user.author_of?(@resource)

    vote = @votes.find_by(votable: @resource)
    @resource.unvote(current_user)
    @resource.downvote(current_user) unless vote
    send_json
  end

  private

  def set_votes
    @votes = current_user&.votes
  end

  def set_resource
    @resource = controller_name.classify.constantize.find(params[:id])
  end

  def send_json
    render json: { id: @resource.id, score: @resource.score }
  end
end