shared_examples_for 'Controller_Votable' do
  describe 'POST #upvote' do
    context 'authored' do
      before do
        login(other_user)
        post :upvote, params: { id: resource }, format: :json
      end

      it 'creates an upvote' do
        resource.reload

        expect(resource.votes.upvotes.count).to eq(1)
      end

      it 'changes the score' do
        resource.reload

        expect(resource.score).to eq(1)
      end
    end

    context 'unauthored' do
      before do
        post :upvote, params: { id: resource }, format: :json
      end

      it 'does not upvote' do
        resource.reload

        expect(resource.votes.count).to eq(0)
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
        post :downvote, params: { id: resource }, format: :json
      end

      it 'creates a downvote' do
        resource.reload

        expect(resource.votes.downvotes.count).to eq(1)
      end

      it 'changes the score' do
        resource.reload

        expect(resource.score).to eq(-1)
      end
    end

    context 'unauthored' do
      before do
        post :downvote, params: { id: resource }, format: :json
      end

      it 'does not downvote' do
        resource.reload

        expect(resource.votes.count).to eq(0)
      end

      it 'gets a response with forbidden status' do
        expect(response.status).to eq(401)
      end
    end
  end
end