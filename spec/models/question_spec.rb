require 'rails_helper'

RSpec.describe Question, type: :model do
  it { should validate_presence_of :title }
  it { should validate_presence_of :body }

  it { should have_many :answers }

  it "all answers deleted when question delete" do
    question = Question.new(body: "First", title: "First question")

    answers = Answer.all.count

    question.answers.new(body: "Hello 1")
    question.answers.new(body: "Hello 2")

    question.save!

    expect(Answer.all.count).to_not eq answers

    question.destroy!
    expect(Answer.all.count).to eq answers
  end
end
