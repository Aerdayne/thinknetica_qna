require 'rails_helper'

RSpec.describe LinksController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }
  let(:answer) { create(:answer, :unique, user: user, question: question) }
  let!(:link) { create(:link, linkable: answer) }

  describe "DELETE #destroy" do
    it 'authored deletes a link' do
      login(user)
      expect { delete :destroy, params: { id: link.id, format: :js } }.to change(Link, :count).by(-1)
    end

    it 'unauthored does not delete a link' do
      expect { delete :destroy, params: { id: link.id, format: :js } }.to_not change(Link, :count)
    end
  end
end
