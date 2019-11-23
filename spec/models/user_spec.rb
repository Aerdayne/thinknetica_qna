require 'rails_helper'

RSpec.describe User, type: :model do
  it { should validate_presence_of :email }
  it { should validate_presence_of :password }

  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:questions).dependent(:destroy) }

  describe '#author_of?' do
    let(:user) { create(:user) }
    let(:question) { create(:question, user: user) }
    let(:other_user) { create(:user) }

    it 'is true' do
      expect(user).to be_author_of(question)
    end

    it 'is false' do
      expect(other_user).to_not be_author_of(question)
    end
  end
end
