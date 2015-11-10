FactoryGirl.define do
  factory :question do
    title "MyString"
    body "MyText"

    factory :question_with_answers do
      transient do
        answer_count 5
      end

      after(:create) do |question, evaluator|
        create_list(:answer, evaluator.answer_count, question: question)
      end
    end
  end

  factory :wrong_question, class: "Question" do
    title nil
    body nil
  end
end
