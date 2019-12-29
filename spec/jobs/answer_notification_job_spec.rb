require 'rails_helper'

RSpec.describe AnswerNotificationJob, type: :job do
  let(:service) { double('AnswerNotification') }
  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }
  let(:answer) { create(:answer, question: question, user: user) }

  before do
    allow(AnswerNotification).to receive(:new).and_return(service)
  end

  it 'calls AnswerNotification#send_notification' do
    expect(service).to receive(:send_notification).with(answer)
    AnswerNotificationJob.perform_now(answer)
  end
end