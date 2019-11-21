require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }
  let(:answer) { create(:answer, user: user, question: question) }

  describe 'POST #create' do
    before { login(user) }

    context 'with valid attributes' do
      it 'saves a new answer in the database' do
        expect { post :create, params: { question_id: question, answer: attributes_for(:answer) } }.to change(question.answers, :count).by(1)
      end

      it 'redirects to questions/show view' do
        post :create, params: { question_id: question, answer: attributes_for(:answer) }
        expect(response).to redirect_to question
      end
    end

    context 'with invalid attributes' do
      it 'does not save a new answer in the database' do
        expect { post :create, params: { question_id: question, answer: attributes_for(:answer, :invalid) } }.to_not change(Answer, :count)
      end

      it 're-renders questions/show view' do
        post :create, params: { question_id: question, answer: attributes_for(:answer, :invalid) }
        expect(response).to render_template 'questions/show'
      end
    end
  end

  describe 'PATCH #update' do
    before { login(user) }

    context 'with valid attributes' do
      it 'assigns the requested answer to @answer' do
        post :update, params: { id: answer, answer: attributes_for(:answer) }
        expect(controller.send(:answer)).to eq(answer)
      end

      it 'changes answer attributes' do
        post :update, params: { id: answer, answer: { body: 'new body' } }
        answer.reload

        expect(answer.body).to eq('new body')
      end

      it 'redirects to updated question' do
        patch :update, params: { id: answer, answer: attributes_for(:answer) }
        expect(response).to redirect_to answer
      end
    end

    context 'with invalid attributes' do
      before { patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid) } }

      it 'does not change answer' do
        answer.reload

        expect(answer.body).to eq('MyString')
      end

      it 're-renders edit view' do
        expect(response).to render_template :edit
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'authored' do
      before { login(user) }
      let!(:answer) { create(:answer, question: question, user: user) }

      it 'deletes the answer' do
        expect { delete :destroy, params: { id: answer } }.to change(Answer, :count).by(-1)
      end

      it 'redirected to question view' do
        delete :destroy, params: { question_id: question, id: answer }
        expect(response).to redirect_to question_path(question)
      end
    end

    context 'unauthored' do
      let!(:answer) { create(:answer, question: question, user: user) }

      it 'does not delete the answer' do
        expect { delete :destroy, params: { question_id: question, id: answer } }.to_not change(Answer, :count)
      end

      it 'redirected to new_user_session_path' do
        delete :destroy, params: { id: answer }
        expect(response).to redirect_to new_user_session_path
      end
    end
  end
end
