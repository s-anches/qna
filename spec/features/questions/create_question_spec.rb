require 'rails_helper'

feature 'User can create new question', %q{
  In order to get answer from community
  As an authenticated user
  I want to be able to ask questions
} do

  scenario 'Authenticated user try to create question with valid attributes' do
    User.create!(email: 'user@example.com', password: '12345678')

    visit new_user_session_path
    fill_in 'Email', with: 'user@example.com'
    fill_in 'Password', with: '12345678'
    click_on 'Log in'

    save_new_question("First question", "This is first question")

    expect(page).to have_content "New question successfully created"
    expect(page).to have_content "First question"
    expect(page).to have_content "This is first question"
  end

  scenario 'Authenticated user try to create question with invalid attributes' do
    User.create!(email: 'user@example.com', password: '12345678')

    visit new_user_session_path
    fill_in 'Email', with: 'user@example.com'
    fill_in 'Password', with: '12345678'
    click_on 'Log in'

    save_new_question

    expect(page).to have_content "Some errors occured"
  end

  scenario 'Non-authenticated user try to create question' do
    visit new_question_path

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
    expect(current_path).to eq new_user_session_path
  end

end