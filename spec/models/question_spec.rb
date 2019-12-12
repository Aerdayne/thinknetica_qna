require 'rails_helper'

RSpec.describe Question, type: :model do
  it { should validate_presence_of :title }
  it { should validate_presence_of :body }
  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:links).dependent(:destroy) }
  it { should have_one(:reward).dependent(:destroy) }
  it { should accept_nested_attributes_for :links }
  it { should accept_nested_attributes_for :reward }


  it 'has many attached files' do
    expect(Question.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
  end

  describe 'instance methods' do
    let(:user) { create(:user) }
    let!(:question) { create(:question, user: user) }

    describe '#upvote' do
      before { question.upvote(question.user) }

      it 'should create a vote' do
        expect(question.votes.upvotes.count).to eq(1)
      end

      it 'should update the score' do
        expect(question.score).to eq(1)
      end
    end

    describe '#downvote' do
      before { question.downvote(question.user) }

      it 'should create a vote' do
        expect(question.votes.downvotes.count).to eq(1)
      end

      it 'should update the score' do
        expect(question.score).to eq(-1)
      end
    end

    describe '#unvote' do
      before do
        question.upvote(question.user)
        question.unvote(question.user)
      end

      it 'should clear the vote' do
        expect(question.votes.count).to eq(0)
      end

      it 'should update the score' do
        expect(question.score).to eq(0)
      end
    end
  end
end
