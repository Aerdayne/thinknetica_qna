require 'rails_helper'

describe 'Questions API', type: :request do
  let(:headers) do
    { 'CONTENT_TYPE' => 'application/json',
      'ACCEPT' => 'application/json' }
  end

  describe 'GET /api/v1/questions' do
    let(:api_path) { '/api/v1/questions' }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do
      let!(:user) { create(:user) }
      let(:access_token) { create(:access_token) }
      let!(:questions) { create_list(:question, 2, user: user) }
      let(:question) { questions.first }
      let(:question_response) { json['questions'].first }
      let!(:answers) { create_list(:answer, 3, question: question, user: user) }

      before { get api_path, params: { access_token: access_token.token }, headers: headers }

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'returns list of questions' do
        expect(json['questions'].size).to eq 2
      end

      it 'returns all public fields' do
        %w[id title body created_at updated_at].each do |attr|
          expect(question_response[attr]).to eq question.send(attr).as_json
        end
      end

      it 'contains user object' do
        expect(question_response['user']['id']).to eq question.user.id
      end

      it 'contains short title' do
        expect(question_response['short_title']).to eq question.title.truncate(7)
      end

      describe 'answers' do
        let(:answer) { answers.last }
        let(:answer_response) { question_response['answers'].first }

        it 'returns list of answers' do
          expect(question_response['answers'].size).to eq 3
        end

        it 'returns all public fields' do
          %w[id body best created_at updated_at score].each do |attr|
            expect(answer_response[attr]).to eq answer.send(attr).as_json
          end
        end
      end
    end
  end

  describe 'GET /api/v1/questions/:id' do
    let!(:user) { create(:user) }
    let!(:question) { create(:question, user: user) }
    let(:api_path) { api_v1_question_path(question) }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let!(:answers) { create_list(:answer, 2, question: question, user: user) }
      let!(:links) { create_list(:link, 2, linkable: question) }
      let!(:comments) { create_list(:comment, 2, commentable: question, user: user) }
      before do
        question.files.attach(io: File.open("#{Rails.root}/spec/spec_helper.rb"), filename: 'spec_helper.rb', content_type: 'image')
      end
      let(:question_response) { json['question'] }

      before { get api_path, params: { access_token: access_token.token }, headers: headers }

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'returns all public fields' do
        %w[id title body created_at updated_at score].each do |attr|
          expect(question_response[attr]).to eq question.send(attr).as_json
        end
      end

      it 'contains user object' do
        expect(question_response['user']['id']).to eq question.user.id
      end

      it 'contains short title' do
        expect(question_response['short_title']).to eq question.title.truncate(7)
      end

      describe 'answers' do
        let(:answer) { answers.last }
        let(:answer_response) { question_response['answers'].first }

        it 'returns list of answers' do
          expect(question_response['answers'].size).to eq 2
        end

        it 'returns all public fields' do
          %w[id body created_at updated_at score].each do |attr|
            expect(answer_response[attr]).to eq answer.send(attr).as_json
          end
        end
      end

      describe 'links' do
        let(:link) { links.last }
        let(:link_response) { question_response['links'].first }

        it 'returns list of links' do
          expect(question_response['links'].size).to eq 2
        end

        it 'returns all public fields' do
          %w[id name url created_at updated_at].each do |attr|
            expect(link_response[attr]).to eq link.send(attr).as_json
          end
        end
      end

      describe 'comments' do
        let(:comment_response) { question_response['comments'].first }
        let(:comment) { comments.last }

        it 'returns list of comments' do
          expect(question_response['comments'].size).to eq 2
        end

        it 'returns all public fields' do
          %w[id content created_at updated_at].each do |attr|
            expect(comment_response[attr]).to eq comment.send(attr).as_json
          end
        end
      end

      describe 'files' do
        let(:file_response) { question_response['files'].first }

        it 'returns the file' do
          expect(file_response.size).to eq 1
        end

        it 'returns all public fields' do
          expect(file_response).to have_key 'url'
        end
      end
    end
  end

  describe 'POST /api/v1/questions' do
    let(:headers) { { 'ACCEPT' => 'application/json' } }
    let(:user) { create(:user) }
    let(:api_path) { api_v1_questions_path }

    it_behaves_like 'API Authorizable' do
      let(:method) { :post }
    end

    describe 'authorized' do
      let(:access_token) { create(:access_token) }
      let(:question_parameters) { { title: 'api_title', body: 'api_body' } }
      let(:question_response) { json['question'] }

      it 'returns 200 status' do
        post api_path, params: { access_token: access_token.token, question: question_parameters }, headers: headers

        expect(response).to be_successful
      end

      it 'saves the question' do
        expect { post api_path, params: { access_token: access_token.token, question: question_parameters }, headers: headers }.to change(Question, :count).by(1)
      end
    end
  end

  describe 'PATCH /api/v1/questions/:id' do
    let(:headers) { { 'ACCEPT' => 'application/json' } }
    let(:user) { create(:user) }
    let!(:question) { create(:question, user: user) }
    let(:api_path) { api_v1_question_path(question) }

    it_behaves_like 'API Authorizable' do
      let(:method) { :patch }
    end

    context 'authorized' do
      let(:access_token) { create(:access_token, resource_owner_id: user.id ) }
      let(:question_parameters) { { title: 'updated_api_title', body: 'updated_api_body' } }
      let(:question_response) { json['question'] }

      it 'returns 200 status' do
        patch api_v1_question_path(question), params: { access_token: access_token.token, question: question_parameters }, headers: headers

        expect(response).to be_successful
      end

      it 'updates the question' do
        patch api_v1_question_path(question), params: { access_token: access_token.token, question: question_parameters }, headers: headers

        question.reload
        expect(question.title).to eq 'updated_api_title'
        expect(question.body).to eq 'updated_api_body'
      end
    end
  end

  describe 'DELETE /api/v1/questions/:id' do
    let(:headers) { { "ACCEPT" => 'application/json' } }
    let(:user) { create(:user) }
    let!(:question) { create(:question, user: user) }
    let(:api_path) { api_v1_question_path(question) }

    it_behaves_like 'API Authorizable' do
      let(:method) { :delete }
    end

    context 'authorized' do
      let(:access_token) { create(:access_token, resource_owner_id: user.id ) }

      it 'returns 200 status' do
        delete api_v1_question_path(question), params: { access_token: access_token.token }, headers: headers

        expect(response).to be_successful
      end

      it 'deletes the answer' do
        expect { delete api_v1_question_path(question), params: { access_token: access_token.token }, headers: headers }.to change(Question, :count).by(-1)
      end
    end
  end
end
