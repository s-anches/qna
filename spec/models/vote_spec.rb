require 'rails_helper'

RSpec.describe Vote, type: :model do
  it { should belong_to :votable }
  it { should belong_to :user }
  it { should validate_presence_of :user_id }

  let(:question) { create :question }
  let(:user_one) { create :user }
  let(:user_two) { create :user }
  let(:user_three) { create :user }
  let!(:vote_one) {
    create :vote,
    votable: question,
    user: user_one,
    value: 1
  }

  let!(:vote_two) {
    create :vote,
    votable: question,
    user: user_two,
    value: 1
  }

  let!(:vote_three) {
    create :vote,
    votable: question,
    user: user_three,
    value: -1
  }

  describe 'scopes' do
    it 'likes return only liked votes' do
      expect(Vote.likes).to eq ([vote_one, vote_two])
    end

    it 'dislikes return only disliked votes' do
      expect(Vote.dislikes).to eq ([vote_three])
    end
  end

end
