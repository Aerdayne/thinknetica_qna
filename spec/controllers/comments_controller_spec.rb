require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }
  let(:other_user) { create(:user) }

  describe 'POST #create' do
    context 'authored' do
      before { login(user) }

      context 'with valid attributes' do
        it 'saves a new comment to the database' do
          expect { post :create, params: { question_id: question, comment: attributes_for(:comment) }, format: :js }.to change(question.comments, :count).by(1)
        end

        it 'comment belongs to a user' do
          post :create, params: { question_id: question, comment: attributes_for(:comment) }, format: :js
          expect(assigns(:comment).user).to eq(user)
        end
      end
    end

    context 'unauthored' do
      it 'does not create the comment' do
        expect { post :create, params: { question_id: question, comment: attributes_for(:comment) }, format: :js }.to_not change(question.comments, :count)
      end

      it 'gets an invalid response' do
        post :create, params: { question_id: question, comment: attributes_for(:comment) }, format: :js 
        expect(response.status).to eq(401)
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'authored' do
      before { login(user) }
      let!(:comment) { create(:comment, commentable: question, user: user) }

      it 'deletes the answer' do
        expect { delete :destroy, params: { id: comment }, format: :js }.to change(Comment, :count).by(-1)
      end
    end

    context 'unauthored' do
      let!(:comment) { create(:comment, commentable: question, user: user) }

      it 'does not delete the answer' do
        expect { delete :destroy, params: { question_id: question, id: comment }, format: :js }.to_not change(Comment, :count)
      end

      it 'redirected to new_user_session_path' do
        delete :destroy, params: { id: comment }
        expect(response).to redirect_to new_user_session_path
      end
    end
  end
end
