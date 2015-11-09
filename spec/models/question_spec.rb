require 'rails_helper'

RSpec.describe Question, type: :model do
  it { should validate_presence_of :title }
  it { should validate_presence_of :body }

  it { should have_many :answers }

  context "answers" do
    question = Question.new(body: "First", title: "First question")
    answers = Answer.all.count

    it "created and saved" do
      question.answers.new(body: "Hello 1")
      question.answers.new(body: "Hello 2")

      question.save!

      expect(Answer.all.count).to_not eq answers
    end

    it "deleted when this question is deleted" do
      question.destroy!
      expect(Answer.all.count).to eq answers
    end
  end
end
