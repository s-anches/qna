require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should validate_presence_of :body }
  it { should validate_presence_of :question_id }
  it { should validate_presence_of :user_id }

  it { should belong_to :question }
  it { should belong_to :user }

  describe "default scope" do
    let(:question) { create :question }
    let!(:answer_one) { create :answer, question: question, created_at: "2015-11-20 13:45:37" }
    let!(:answer_two) { create :answer, question: question, created_at: "2015-11-20 13:45:38" }
    let!(:answer_best) { create :answer, question: question, best: true, created_at: "2015-11-20 13:45:39" }

    it "return latest create answer as first" do
      expect(question.reload.answers).to eq ([answer_best, answer_one, answer_two])
    end
  end

  describe "#set_best method" do
    let!(:answer) { create :answer }

    it "set answer best" do
      expect(answer.best?).to eq false
      answer.set_best
      expect(answer.best?).to eq true
    end
  end
end
