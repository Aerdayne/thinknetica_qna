require 'rails_helper'

RSpec.describe DailyDigest do
  let(:users) { create_list(:user, 3) }
  let!(:questions) { create_list(:question, 5, user: users.first) }
  let!(:questions_ids) { questions.pluck(:id) }
  it 'sends daily digest to all users' do
    users.each { |user| expect(DailyDigestMailer).to receive(:digest).with(user, questions_ids).and_call_original }
    subject.send_digest
  end
end