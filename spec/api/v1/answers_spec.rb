require 'rails_helper'

describe 'Answers API', type: :request do
  let(:headers) do
    { 'CONTENT_TYPE' => 'application/json',
      'ACCEPT' => 'application/json' }
  end

  describe 'GET /api/v1/answers/:id' do
    let(:user) { create(:user) }
    let!(:question) { create(:question, user: user) }
    let!(:answer) { create(:answer, user: user, question: question) }
    let(:api_path) { api_v1_answer_path(answer) }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let!(:links) { create_list(:link, 2, linkable: answer) }
      let!(:comments) { create_list(:comment, 2, commentable: answer, user: user) }
      before do
        answer.files.attach(io: File.open("#{Rails.root}/spec/spec_helper.rb"), filename: 'spec_helper.rb', content_type: 'image')
      end
      let(:answer_response) { json['answer'] }

      before { get api_path, params: { access_token: access_token.token }, headers: headers }

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'returns all public fields' do
        %w[id body created_at updated_at score best].each do |attr|
          expect(answer_response[attr]).to eq answer.send(attr).as_json
        end
      end

      describe 'links' do
        let(:link) { links.last }
        let(:link_response) { answer_response['links'].first }

        it 'returns list of links' do
          expect(answer_response['links'].size).to eq 2
        end

        it 'returns all public fields' do
          %w[id url name created_at updated_at].each do |attr|
            expect(link_response[attr]).to eq link.send(attr).as_json
          end
        end
      end

      describe 'comments' do
        let(:comment_response) { answer_response['comments'].first }
        let(:comment) { comments.last }

        it 'returns list of comments' do
          expect(answer_response['comments'].size).to eq 2
        end

        it 'returns all public fields' do
          %w[id content created_at updated_at].each do |attr|
            expect(comment_response[attr]).to eq comment.send(attr).as_json
          end
        end
      end

      describe 'files' do
        let(:file_response) { answer_response['files'] }

        it 'returns the file' do
          expect(file_response.size).to eq 1
        end

        it 'returns all public fields' do
          expect(file_response.first).to have_key 'url'
        end
      end
    end
  end

  describe 'POST /api/v1/answers' do
    let(:headers) { { 'ACCEPT' => 'application/json' } }
    let(:user) { create(:user) }
    let!(:question) { create(:question, user: user) }
    let(:api_path) { api_v1_question_answers_path(question) }

    it_behaves_like 'API Authorizable' do
      let(:method) { :post }
    end

    describe 'authorized' do
      let(:access_token) { create(:access_token) }
      let(:answer_parameters) { { body: 'api_body' } }
      let(:question_response) { json['answer'] }

      before { post api_path, params: { access_token: access_token.token, answer: answer_parameters }, headers: headers }

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'saves the answer' do
        expect { post api_path, params: { access_token: access_token.token, answer: answer_parameters }, headers: headers }.to change(question.answers, :count).by(1)
      end
    end
  end

  describe 'PATCH /api/v1/answers/:id' do
    let(:headers) { { 'ACCEPT' => 'application/json' } }
    let(:user) { create(:user) }
    let!(:question) { create(:question, user: user) }
    let!(:answer) { create(:answer, question: question, user: user) }
    let(:api_path) { api_v1_question_path(question) }

    it_behaves_like 'API Authorizable' do
      let(:method) { :patch }
    end

    context 'authorized' do
      let(:access_token) { create(:access_token, resource_owner_id: user.id ) }
      let(:answer_parameters) { { body: 'updated_api_body' } }
      let(:question_response) { json['answer'] }

      it 'returns 200 status' do
        patch api_v1_answer_path(answer), params: { access_token: access_token.token, answer: answer_parameters }, headers: headers

        expect(response).to be_successful
      end

      it 'updates the answer' do
        patch api_v1_answer_path(answer), params: { access_token: access_token.token, answer: answer_parameters }, headers: headers

        answer.reload
        expect(answer.body).to eq 'updated_api_body'
      end
    end
  end

  describe 'DELETE /api/v1/answers/:id' do
    let(:headers) { { 'ACCEPT' => 'application/json' } }
    let(:user) { create(:user) }
    let!(:question) { create(:question, user: user) }
    let!(:answer) { create(:answer, question: question, user: user) }
    let(:api_path) { api_v1_question_path(question) }

    it_behaves_like 'API Authorizable' do
      let(:method) { :delete }
    end

    context 'authorized' do
      let(:access_token) { create(:access_token, resource_owner_id: user.id ) }

      it 'returns 200 status' do
        delete api_v1_answer_path(answer), params: { access_token: access_token.token }, headers: headers

        expect(response).to be_successful
      end

      it 'deletes the answer' do
        expect { delete api_v1_answer_path(answer), params: { access_token: access_token.token }, headers: headers }.to change(Answer, :count).by(-1)
      end
    end
  end
end
