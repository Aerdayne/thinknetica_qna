require 'rails_helper'

RSpec.describe SubscriptionsController, type: :controller do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  let(:question) { create(:question, :unique, user: user) }

  describe 'POST #create' do
    context 'authored' do
      before do
        login(other_user)
        post :create, params: { question_id: question, format: :js }
      end

      it 'creates a subscription' do
        question.reload

        expect(question.subscriptions.count).to eq(1)
      end
    end

    context 'unauthored' do
      before do
        post :create, params: { question_id: question, format: :js }
      end

      it 'does not create a subscription' do
        question.reload

        expect(question.subscriptions.count).to eq(0)
      end

      it 'gets a response with forbidden status' do
        expect(response.status).to eq(401)
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'authored' do
      before do
        login(other_user)
        post :create, params: { question_id: question, format: :js }
        delete :destroy, params: { question_id: question, format: :js }
      end

      it 'deletes a subscription' do
        question.reload

        expect(question.subscriptions.count).to eq(0)
      end
    end

    context 'unauthored' do
      before do
        post :destroy, params: { question_id: question, format: :js }
      end

      it 'does not delete a subscription' do
        question.reload

        expect(question.subscriptions.count).to eq(0)
      end

      it 'gets a response with forbidden status' do
        expect(response.status).to eq(401)
      end
    end
  end
end
