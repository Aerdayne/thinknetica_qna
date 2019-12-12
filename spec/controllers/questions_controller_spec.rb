require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  let(:question) { create(:question, :unique, user: user) }

  describe 'GET #show' do
    before { get :show, params: { id: question } }

    it 'assigns the requested question to @question' do
      expect(controller.send(:question)).to eq question
    end

    it 'assigns a new Answer record to @answer' do
      expect(assigns(:answer)).to be_a_new(Answer)
    end

    it 'adds a new Link record to @answer.links relation' do
      expect(assigns(:answer).links.first).to be_a_new(Link)
    end

    it 'renders show view' do
      expect(response).to render_template :show
    end
  end

  describe 'GET #new' do
    before { login(user) }

    before { get :new }

    it 'assigns a new Question to @question' do
      expect(assigns(:question)).to be_a_new(Question)
    end

    it 'adds a new Link to @question.links relation' do
      expect(assigns(:question).links.first).to be_a_new(Link)
    end

    it 'assigns a new Reward to @reward' do
      expect(assigns(:reward)).to be_a_new(Reward)
    end

    it 'renders new view' do
      expect(response).to render_template :new
    end
  end

  describe 'POST #create' do
    before { login(user) }

    context 'with valid attributes' do
      it 'saves a new question to the database' do
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
      it 'does not save a new question to the database' do
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

  describe 'POST #upvote' do
    context 'authored' do
      before do
        login(other_user)
        post :upvote, params: { id: question }, format: :json
      end

      it 'creates an upvote' do
        question.reload

        expect(question.votes.upvotes.count).to eq(1)
      end

      it 'changes the score' do
        question.reload

        expect(question.score).to eq(1)
      end
    end

    context 'unauthored' do
      before do
        post :upvote, params: { id: question }, format: :json
      end

      it 'does not upvote' do
        question.reload

        expect(question.votes.count).to eq(0)
      end

      it 'gets a response with forbidden status' do
        expect(response.status).to eq(401)
      end
    end
  end

  describe 'POST #downvote' do
    context 'authored' do
      before do
        login(other_user)
        post :downvote, params: { id: question }, format: :json
      end

      it 'creates a downvote' do
        question.reload

        expect(question.votes.downvotes.count).to eq(1)
      end

      it 'changes the score' do
        question.reload

        expect(question.score).to eq(-1)
      end
    end

    context 'unauthored' do
      before do
        post :downvote, params: { id: question }, format: :json
      end

      it 'does not downvote' do
        question.reload

        expect(question.votes.count).to eq(0)
      end

      it 'gets a response with forbidden status' do
        expect(response.status).to eq(401)
      end
    end
  end
end
