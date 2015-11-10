FactoryGirl.define do
  factory :answer do
    body "MyTest"
  end

  factory :wrong_answer, class: "Answer" do
    body nil
  end
  # factory :answer do
  #   body "MyText"
  #   questions

  #   factory :question do
  #     title "MyTitle"
  #     body "MyBody"
  #
  #     factory :question_with_answers do
  #       transient do
  #         answer_count 5
  #       end
  #
  #       after(:create) do |question, evaluator|
  #         create_list(:answer, evaluator.answer_count, questio: questio)
  #       end
  #     end
  #   end
  # end
end
