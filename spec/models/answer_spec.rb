require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should validate_presence_of :body }
  it { should validate_presence_of :question_id }
  it { should validate_presence_of :user_id }

  it { should belong_to :question }
  it { should belong_to :user }


  let(:question) { create :question }
  let!(:answer_one) { create :answer, question: question, created_at: "2015-11-20 13:45:37" }
  let!(:answer_two) { create :answer, question: question, created_at: "2015-11-20 13:45:38" }
  let!(:answer_best) { create :answer, question: question, best: true, created_at: "2015-11-20 13:45:39" }

  describe "default scope" do
    it "return best answer first and latest create answer first" do
      expect(question.reload.answers).to eq ([answer_best, answer_one, answer_two])
    end
  end

  describe "#set_best method" do
    it "set answer best" do
      expect(answer_one.best?).to eq false

      answer_one.set_best

      expect(answer_one.best?).to eq true
    end

    it "set old best answer to false" do
      expect(answer_best.best?).to eq true

      answer_one.set_best
      answer_best.reload

      expect(answer_best.best?).to eq false
      expect(answer_one.best?).to eq true
    end
  end
end
