require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question, :unique, user: user) }

  describe 'POST #create' do
    before { login(user) }

    context 'with valid attributes' do
      it 'saves a new question in the database' do
        expect { post :create, params: { question: attributes_for(:question) } }.to change(Question, :count).by(1)
      end

      it 'redirects to show view' do
        post :create, params: { question: attributes_for(:question) }
        expect(response).to redirect_to assigns(:question)
      end

      it 'belongs to a user' do
        post :create, params: { question: attributes_for(:question) }
        expect(assigns(:question).user).to eq(user) 
      end
    end

    context 'with invalid attributes' do
      it 'does not save a new question in the database' do
        expect { post :create, params: { question: attributes_for(:question, :invalid) } }.to_not change(Question, :count)
      end

      it 're-renders new view' do
        post :create, params: { question: attributes_for(:question, :invalid) }
        expect(response).to render_template :new
      end
    end
  end

  describe 'PATCH #update' do
    context 'authored' do
      before { login(user) }
      context 'with valid attributes' do
        it 'assigns the requested question to @question' do
          post :update, params: { id: question, question: attributes_for(:question), format: :js }
          expect(controller.send(:question)).to eq(question)
        end

        it 'changes question attributes' do
          post :update, params: { id: question, question: { title: 'new title', body: 'new body' }, format: :js }
          question.reload

          expect(question.title).to eq('new title')
          expect(question.body).to eq('new body')
        end

        it 'redirects to updated question' do
          patch :update, params: { id: question, question: attributes_for(:question), format: :js }
          expect(response).to redirect_to question
        end
      end

      context 'with invalid attributes' do
        it 'does not change question' do
          question.reload

          expect do
            patch :update, params: { id: question, question: attributes_for(:question, :invalid), format: :js }
          end.to_not change(question, :body)
        end

        it 're-renders update view' do
          patch :update, params: { id: question, question: attributes_for(:question, :invalid), format: :js }
          expect(response).to render_template :update
        end
      end
    end

    context 'unauthored' do
      it 'does not update the question' do
        question.reload

        expect { patch :update, params: { id: question, question: { user: user, title: 'changed title', body: 'changed body' } }, format: :js }.to_not change(question, :body)
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'authored' do
      before { login(user) }
      let!(:question) { create(:question, user: user) }

      it 'deletes the question' do
        expect { delete :destroy, params: { id: question } }.to change(Question, :count).by(-1)
      end

      it 'redirected to questions view' do
        delete :destroy, params: { id: question }
        expect(response).to redirect_to questions_path
      end
    end

    context 'unauthored' do
      let!(:question) { create(:question, user: user) }

      it 'does not delete the question' do
        expect { delete :destroy, params: { id: question } }.to_not change(Question, :count)
      end

      it 'redirected to new_user_session_path' do
        delete :destroy, params: { id: question }
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe "PATCH #destroy_attachment" do
    before do
      file = fixture_file_upload(Rails.root.join('spec', 'rails_helper.rb'), 'image/png')
      login(user)
      post :update, params: { id: question, question: { files: [file] }, format: :js }
      sign_out(user)
    end

    it 'authored deletes an attachment' do
      login(user)
      expect { delete :destroy_attachment, params: { id: question, file_id: question.files.first.id, format: :js } }.to change(question.files, :count).by(-1)
    end

    it 'unauthored does not delete an attachment' do
      expect { delete :destroy_attachment, params: { id: question, file_id: question.files.first.id, format: :js } }.to_not change(question.files, :count)
    end
  end
end
