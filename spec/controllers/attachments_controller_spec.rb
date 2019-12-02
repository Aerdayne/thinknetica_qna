require 'rails_helper'

RSpec.describe AttachmentsController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }
  let(:answer) { create(:answer, :unique, user: user, question: question) }

  describe "DELETE #destroy" do
    before do
      file = fixture_file_upload(Rails.root.join('spec', 'rails_helper.rb'), 'image/png')
      answer.files.attach(file)
    end

    it 'authored deletes an attachment' do
      login(user)
      expect { delete :destroy, params: { id: answer.files.first.id, format: :js } }.to change(answer.files, :count).by(-1)
    end

    it 'unauthored does not delete an attachment' do
      expect { delete :destroy, params: { id: answer.files.first.id, format: :js } }.to_not change(answer.files, :count)
    end
  end
end