require 'rails_helper'

describe Ability, type: :model do
  subject(:ability) { Ability.new(user) }

  describe 'for guest' do
    let(:user) { nil }

    it { should be_able_to :read, Question }
    it { should be_able_to :read, Answer }
    it { should be_able_to :read, Comment }

    it { should_not be_able_to :manage, :all }
  end

  describe 'for admin' do
    let(:user) { create :user, admin: true }

    it { should be_able_to :manage, :all }
  end

  describe 'for user' do
    let!(:user) { create :user }
    let!(:user_other) { create :user }
    let(:question) { create(:question, user: user) }
    let(:question_other) { create(:question, user: user_other) }
    let(:answer) { create(:answer, question: question, user: user) }
    let(:answer_other) { create(:answer, question: question_other, user: user_other) }
    let(:comment) { create(:comment, user: user, commentable: question) }
    let(:comment_other) { create(:comment, user: user_other, commentable: question) }

    it { should_not be_able_to :manage, :all }
    it { should be_able_to :read, :all }

    it { should be_able_to :create, Question }
    it { should be_able_to :create, Answer }
    it { should be_able_to :create, Comment }
    it { should be_able_to :create, Reward }
    it { should be_able_to :create, Link }

    it { should be_able_to :update, question, user: user }
    it { should be_able_to :update, answer, user: user }
    it { should_not be_able_to :update, question_other, user: user }
    it { should_not be_able_to :update, answer_other, user: user }

    it { should be_able_to :destroy, question, user: user }
    it { should be_able_to :destroy, answer, user: user }
    it { should be_able_to :destroy, comment, user: user }
    it { should_not be_able_to :destroy, question_other, user: user }
    it { should_not be_able_to :destroy, answer_other, user: user }
    it { should_not be_able_to :destroy, comment_other, user: user }

    it { should be_able_to :set_best, answer, user: user }
    it { should be_able_to :upvote, answer_other, user: user_other }
    it { should be_able_to :downvote, answer_other, user: user_other }
    it { should be_able_to :upvote, question_other, user: user_other }
    it { should be_able_to :downvote, question_other, user: user_other }
    it { should_not be_able_to :set_best, answer_other, user: user_other }
    it { should_not be_able_to :upvote, answer, user: user }
    it { should_not be_able_to :downvote, answer, user: user }
    it { should_not be_able_to :upvote, question, user: user }
    it { should_not be_able_to :downvote, question, user: user }
  end
end