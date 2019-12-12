require 'rails_helper'

RSpec.shared_examples_for "votable" do
  it { should have_many(:votes).dependent(:destroy) }

  let(:model) { described_class }

  describe '#upvote' do
    it 'should create a vote' do
      expect(model.upvote(model.user)).to change(model.votes.upvotes, :count).by(1)
    end

    it 'should update the score' do
      expect(model.upvote(model.user)).to change(model.score).by(1)
    end
  end

  describe '#downvote' do
    it 'should create a vote' do
      expect(model.upvote(model.user)).to change(model.votes.downvotes, :count).by(1)
    end

    it 'should update the score' do
      expect(model.downvote(model.user)).to change(model.score).by(-1)
    end
  end

  describe '#unvote' do
    before { model.upvote(model.user) }

    it 'should clear the vote' do
      expect(model.unvote(model.user)).to change(model.votes, :count).by(-1)
    end

    it 'should update the score' do
      expect(model.unvote(model.user)).to change(model.score).by(-1)
    end
  end
end