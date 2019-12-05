require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should validate_presence_of :body }
  it { should belong_to :question }
  it { should have_many(:links).dependent(:destroy) }
  it { should accept_nested_attributes_for :links }

  describe '#set_best' do
    let(:user) { create(:user) }
    let(:question) { create(:question, user: user) }
    let!(:answer) { create(:answer, question: question, user: user, best: true) }

    it 'does not allow for two answers to both be the best concurrently' do
      other_answer = Answer.new(user: user, question: question, body: '123', best: true)
      other_answer.save

      expect(other_answer).to_not be_valid
    end

    it 'sets the new best answer' do
      other_answer = Answer.create(user: user, question: question, body: '321')
      other_answer.set_best
      other_answer.reload

      expect(other_answer).to be_best
      expect(answer.reload).to_not be_best
    end
  end
end
