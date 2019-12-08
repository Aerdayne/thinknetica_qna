require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should validate_presence_of :body }
  it { should belong_to :question }
  it { should have_many(:links).dependent(:destroy) }
  it { should accept_nested_attributes_for :links }

  describe 'instance methods' do
    let(:user) { create(:user) }
    let(:other_user) { create(:user) }
    let!(:question) { create(:question, user: user) }
    let!(:reward) { create(:reward, question: question, file: fixture_file_upload(Rails.root.join('spec', 'rails_helper.rb'), 'image/png')) }
    let!(:answer) { create(:answer, question: question, user: user, best: false) }
    let!(:other_answer) { create(:answer, question: question, user: other_user, best: false) }

    describe '#set_best' do
      it 'does not allow for two answers to both be the best concurrently' do
        answer.set_best
        answer.reload
        answer_artificial = Answer.new(user: user, question: question, body: '123', best: true)
        answer_artificial.save

        expect(answer_artificial).to_not be_valid
      end

      it 'sets the new best answer' do
        answer.set_best
        other_answer.set_best

        expect(other_answer.reload).to be_best
        expect(answer.reload).to_not be_best
      end

      it 'gives out a reward to the author' do
        answer.set_best
        answer.reload

        expect(reward.user).to eq(answer.user)
      end

      it 'reassigns the reward owner' do
        answer.set_best
        answer.reload
        other_answer.set_best
        other_answer.reload

        expect(reward.user).to eq(other_answer.user)
      end
    end

    describe '#upvote' do
      before { answer.upvote(answer.user) }

      it 'should create a vote' do
        expect(answer.votes.upvotes.count).to eq(1)
      end

      it 'should update the score' do
        expect(answer.score).to eq(1)
      end
    end

    describe '#downvote' do
      before { answer.downvote(answer.user) }

      it 'should create a vote' do
        expect(answer.votes.downvotes.count).to eq(1)
      end

      it 'should update the score' do
        expect(answer.score).to eq(-1)
      end
    end

    describe '#unvote' do
      before do
        answer.upvote(answer.user)
        answer.unvote(answer.user)
      end

      it 'should clear the vote' do
        expect(answer.votes.count).to eq(0)
      end

      it 'should update the score' do
        expect(answer.score).to eq(0)
      end
    end
  end
end
