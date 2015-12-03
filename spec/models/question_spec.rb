require 'rails_helper'

RSpec.describe Question, type: :model do
  it { should validate_presence_of :title }
  it { should validate_presence_of :body }
  it { should validate_presence_of :user_id }

  it { should belong_to :user }
  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:attachments).dependent(:destroy) }
  it { should have_many(:votes).dependent(:destroy) }

  it { should accept_nested_attributes_for :attachments }
  it { should accept_nested_attributes_for :votes }

  let(:user) { create :user }
  let(:question) { create :question }

  describe 'vote and unvote method' do
    before { question.vote(user, 1) }
    it 'set vote to question' do
      expect(question.votes.first.value).to eq 1
    end

    it 'remove vote from question' do
      question.unvote(user)
      expect(question.votes.count).to eq 0
    end
  end

  describe 'is_voted method' do
    it 'return true if user voted' do
      question.vote(user, 1)

      expect(question.is_voted?(user)).to eq true
    end

    it 'return false if user not voted' do
      expect(question.is_voted?(user)).to eq false
    end
  end

  describe 'is_liked method' do
    it 'return true if liked' do
      question.vote(user, 1)

      expect(question.is_liked?(user)).to eq true
    end

    it 'return false if disliked' do
      question.vote(user, -1)

      expect(question.is_liked?(user)).to eq false
    end
  end
end
