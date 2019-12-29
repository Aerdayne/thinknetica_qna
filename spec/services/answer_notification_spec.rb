require 'rails_helper'

RSpec.describe AnswerNotification do
  let!(:user) { create(:user) }
  let(:users) { create_list(:user, 3) }
  let!(:question) { create(:question, user: user) }
  let!(:answer) { create(:answer, question: question, user: user) }

  before do
    users.each { |user| question.subscribe(user) }
  end

  it 'sends notification to all users' do
    users.each { |user| expect(AnswerNotificationMailer).to receive(:notify).with(user, answer, question).and_call_original }
    subject.send_notification(answer)
  end
end