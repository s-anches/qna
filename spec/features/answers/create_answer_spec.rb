require 'rails_helper'

feature 'User can create new answer to question', %q{
  In order to be able to create new answer to question
  As an authenticated user
  I want to be able to send answer
} do

  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }

  scenario 'Authenticated user try to create new answer with valid attributes', js: true do
    sign_in(user)
    save_new_answer(question, "Test answer")

    expect(current_path).to eq question_path(question)
    within '.answers' do
      expect(page).to have_content("Test answer")
    end
  end

  scenario 'Authenticated user try to create new answer with invalid attributes', js: true do
    sign_in(user)
    save_new_answer(question)

    expect(current_path).to eq question_path(question)
    expect(page).to have_content("Body can't be blank")
  end

  scenario 'Non-authenticated user try to create new answer' do
    visit question_path(question)

    expect(page).to_not have_content 'Your answer:'
  end

end