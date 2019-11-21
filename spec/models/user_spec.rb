require 'rails_helper'

RSpec.describe User, type: :model do
  it { should validate_presence_of :email }
  it { should validate_presence_of :password }

  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:questions).dependent(:destroy) }

  describe 'is' do
    let(:user) { create(:user) }
    let(:question) { create(:question, user: user) }

    it 'an author of a record' do
      expect(user).to be_author_of(question)
    end

    let(:other_user) { create(:user) }
    let(:others_question) { create(:question, user: other_user) }

    it 'not an author of a record' do
      expect(user).to_not be_author_of(others_question)
    end
  end
end
