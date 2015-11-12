require 'rails_helper'

feature 'User can create new answer to question', %q{
  In order to be able to create new answer to question
  User need go to question path, click to new answer, fill field and click to save
  User sees question page with answer
} do

  let(:question) { Question.create!(title: "TItle",body: "Test question") }

  scenario 'User try to create new answer with valid attributes' do
    save_new_answer(question, "Test answer")

    expect(current_path).to eq question_path(question)
    expect(page).to have_content("Test answer")
  end

  scenario 'User try to create new answer with invalid attributes' do
    save_new_answer(question)

    expect(page).to have_content("Some errors occured")
  end

end