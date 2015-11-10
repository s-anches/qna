FactoryGirl.define do
  factory :answer do
    body "MyTest"
    question
  end

  factory :wrong_answer, class: "Answer" do
    body nil
  end
end
