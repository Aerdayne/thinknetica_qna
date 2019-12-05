require 'rails_helper'

RSpec.describe Link, type: :model do
  it { should belong_to :linkable }

  it { should validate_presence_of :name }
  it { should validate_presence_of :url }
  it { should allow_value("http://google.com").for(:url) }
  it { should_not allow_value("invalid url").for(:url) }

  describe "#url_is_gist?" do
    let(:user) { create(:user) }
    let(:question) { create(:question, user: user) }
    let!(:gist_link) { create(:link, :gist, linkable: question) }
    let!(:non_gist_link) { create(:link, linkable: question) }

    it 'identifies a gist url' do
      expect(gist_link).to be_url_is_gist
    end

    it 'identifies a non-gist url' do
      expect(non_gist_link).to_not be_url_is_gist
    end
  end
end