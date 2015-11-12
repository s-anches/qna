FactoryGirl.define do
  sequence :email do |n|
    "user#{n}@example.com"
  end

  factory :user do
    email
    password '12345678'
    password_confirmation '12345678'

    factory :user_with_question do
      transient do
        question_count 5
      end

      after(:create) do |user, evaluator|
        create_list(:question, evaluator.question_count, user: user)
      end
    end

  end

end
