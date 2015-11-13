FactoryGirl.define do
  factory :answer do
    user
    question
    body "This is test answer"
  end

  factory :wrong_answer, class: "Answer" do
    user
    question
    body nil
  end
end
