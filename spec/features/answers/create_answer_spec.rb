require 'rails_helper'

feature 'User can create new answer to question', %q{
  In order to be able to create new answer to question
  As an authenticated user
  I want to be able to send answer
} do

  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }

  scenario 'Authenticated user try to create new answer with valid attributes' do
    sign_in(user)
    save_new_answer(question, "Test answer")

    expect(current_path).to eq question_path(question)
    expect(page).to have_content("Test answer")
  end

  scenario 'Authenticated user try to create new answer with invalid attributes' do
    sign_in(user)
    save_new_answer(question)

    expect(page).to have_content("Some errors occured")
  end

  scenario 'Non-authenticated user try to create new answer' do
    visit new_question_answer_path(question)

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
    expect(current_path).to eq new_user_session_path
  end

end