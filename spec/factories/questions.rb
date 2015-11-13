FactoryGirl.define do

  factory :question do
    user
    title "MyString"
    body "MyText"
  end

  factory :wrong_question, class: "Question" do
    user
    title nil
    body nil
  end

end
