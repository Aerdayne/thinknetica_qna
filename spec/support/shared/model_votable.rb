shared_examples_for 'Model_Votable' do
  it { should have_many(:votes).dependent(:destroy) }

  describe '#upvote' do
    before { resource.upvote(resource.user) }

    it 'should create a vote' do
      expect(resource.votes.upvotes.count).to eq(1)
    end

    it 'should update the score' do
      expect(resource.score).to eq(1)
    end
  end

  describe '#downvote' do
    before { resource.downvote(resource.user) }

    it 'should create a vote' do
      expect(resource.votes.downvotes.count).to eq(1)
    end

    it 'should update the score' do
      expect(resource.score).to eq(-1)
    end
  end

  describe '#unvote' do
    before do
      resource.upvote(resource.user)
      resource.unvote(resource.user)
    end

    it 'should clear the vote' do
      expect(resource.votes.count).to eq(0)
    end

    it 'should update the score' do
      expect(resource.score).to eq(0)
    end
  end
end
