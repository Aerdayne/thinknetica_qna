require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }
  let(:answer) { create(:answer, :unique, user: user, question: question) }
  let(:other_user) { create(:user) }
  let(:other_answer) { create(:answer, :other, user: other_user, question: question) }

  describe 'POST #create' do
    before { login(user) }

    context 'with valid attributes' do
      it 'saves a new answer in the database' do
        expect { post :create, params: { question_id: question, answer: attributes_for(:answer) }, format: :js }.to change(question.answers, :count).by(1)
      end

      it 'redirects to questions/show view' do
        post :create, params: { question_id: question, answer: attributes_for(:answer), format: :js }
        expect(response).to render_template :create
      end

      it 'belongs to a user' do
        post :create, params: { question_id: question, answer: attributes_for(:answer), format: :js }
        expect(assigns(:answer).user).to eq(user)
      end
    end

    context 'with invalid attributes' do
      it 'does not save a new answer in the database' do
        expect { post :create, params: { question_id: question, answer: attributes_for(:answer, :invalid) }, format: :js }.to_not change(Answer, :count)
      end

      it 're-renders questions/show view' do
        post :create, params: { question_id: question, answer: attributes_for(:answer, :invalid), format: :js }
        expect(response).to render_template :create
      end
    end
  end

  describe 'PATCH #update' do
    context 'authored' do
      before { login(user) }

      context 'with valid attributes', js: true do
        it 'assigns the requested answer to @answer' do
          post :update, params: { id: answer, answer: attributes_for(:answer), format: :js }
        end

        it 'changes answer attributes' do
          post :update, params: { id: answer, answer: { body: 'new body' }, format: :js  }
          answer.reload

          expect(answer.body).to eq('new body')
        end

        it 'redirects to updated question' do
          patch :update, params: { id: answer, answer: attributes_for(:answer), format: :js }
          expect(response).to redirect_to answer
        end
      end

      context 'with invalid attributes' do
        before { patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid) }, format: :js }

        it 'does not change answer' do
          answer.reload

          expect(answer.body).to eq('an answer')
        end

        it 're-renders update view' do
          expect(response).to render_template :update
        end
      end
    end

    context 'unauthored' do
      it 'does not update the answer' do
        answer.reload

        expect { patch :update, params: { id: answer, answer: { user: user, body: 'changed body' } }, format: :js }.to_not change(answer, :body)
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'authored' do
      before { login(user) }
      let!(:answer) { create(:answer, question: question, user: user) }

      it 'deletes the answer' do
        expect { delete :destroy, params: { id: answer, format: :js } }.to change(Answer, :count).by(-1)
      end

      it 'redirected to answer' do
        delete :destroy, params: { question_id: question, id: answer, format: :js }
        expect(response).to redirect_to answer
      end
    end

    context 'unauthored' do
      let!(:answer) { create(:answer, question: question, user: user) }

      it 'does not delete the answer' do
        expect { delete :destroy, params: { question_id: question, id: answer, format: :js }, format: :js }.to_not change(Answer, :count)
      end

      it 'redirected to new_user_session_path' do
        delete :destroy, params: { id: answer }
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe "PATCH #set_best" do
    context 'authored' do
      before { login(user) }
      before { patch :set_best, params: { id: answer, answer: attributes_for(:answer, :invalid, best: true), format: :js } }

      it 'does change the best value' do
        answer.reload

        expect(answer.best).to eq(true)
      end

      it 'renders set_best' do
        expect(response).to render_template :set_best
      end
    end

    context 'unauthored' do
      before { patch :set_best, params: { id: other_answer, answer: attributes_for(:answer, :invalid), format: :js } }

      it 'does not change the best value' do
        answer.reload

        expect(answer.best).to eq(false)
      end

      it 'gets an invalid response' do
        expect(response.status).to eq(401)
      end
    end
  end

  describe "PATCH #destroy_attachment" do
    before do
      file = fixture_file_upload(Rails.root.join('spec', 'rails_helper.rb'), 'image/png')
      login(user)
      post :update, params: { id: answer, answer: { files: [file] }, format: :js }
      sign_out(user)
    end

    it 'authored deletes an attachment' do
      login(user)
      expect { delete :destroy_attachment, params: { id: answer, file_id: answer.files.first.id, format: :js } }.to change(answer.files, :count).by(-1)
    end

    it 'unauthored does not delete an attachment' do
      expect { delete :destroy_attachment, params: { id: answer, file_id: answer.files.first.id, format: :js } }.to_not change(answer.files, :count)
    end
  end
end
