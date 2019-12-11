module Votable
  extend ActiveSupport::Concern

  included do
    has_many :votes, dependent: :destroy, as: :votable
  end

  def upvote(user)
    votes.create!(user: user, value: 1)
    update_votable_score
  end

  def downvote(user)
    votes.create!(user: user, value: -1)
    update_votable_score
  end

  def unvote(user)
    votes.where(user: user).delete_all
    update_votable_score
  end

  private

  def update_votable_score
    update!(score: votes.sum(:value))
  end
end