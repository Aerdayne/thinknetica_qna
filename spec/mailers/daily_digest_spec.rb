require "rails_helper"

RSpec.describe DailyDigestMailer, type: :mailer do
  describe "digest" do
    let(:user) { create(:user, email: 'to@example.org') }
    let!(:questions) { create_list(:question, 5, user: user) }
    let(:mail) { DailyDigestMailer.digest(user, questions) }

    it "renders the headers" do
      expect(mail.subject).to eq("Digest")
      expect(mail.to).to eq(["to@example.org"])
      expect(mail.from).to eq(["from@example.com"])
    end

    it "renders the body" do
      questions.each do |question|
        expect(mail.body.encoded).to have_text(question.title)
      end
    end
  end
end
