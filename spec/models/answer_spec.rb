require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should validate_presence_of :body }
  it { should belong_to :question }
  it { should have_many(:links).dependent(:destroy) }
  it { should have_many(:comments).dependent(:destroy) }
  it { should accept_nested_attributes_for :links }

  let(:user) { create(:user) }
  let!(:question) { create(:question, user: user) }
  let!(:answer) { create(:answer, question: question, user: user, best: false) }

  it_behaves_like 'Model_Votable' do
    let(:resource) { answer }
  end

  describe 'instance methods' do
    let(:other_user) { create(:user) }
    let!(:reward) { create(:reward, question: question, file: fixture_file_upload(Rails.root.join('spec', 'rails_helper.rb'), 'image/png')) }
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
  end
end
