require 'rails_helper'

RSpec.describe User, type: :model do
  it { should validate_presence_of :email }
  it { should validate_presence_of :password }

  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:questions).dependent(:destroy) }
  it { should have_many(:rewards).dependent(:nullify) }
  it { should have_many(:comments).dependent(:nullify) }
  it { should have_many(:subscriptions).dependent(:destroy) }

  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }

  describe '#author_of?' do
    let(:other_user) { create(:user) }

    it 'is true' do
      expect(user).to be_author_of(question)
    end

    it 'is false' do
      expect(other_user).to_not be_author_of(question)
    end
  end

  describe '#find_subscription' do
    before do
      question.subscribe(user)
    end

    it 'returns a subscription' do
      expect(user.find_subscription(question)).to eq(question.subscriptions.first)
    end
  end
end
