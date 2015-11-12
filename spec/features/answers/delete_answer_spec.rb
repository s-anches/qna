require 'rails_helper'

feature 'User can delete his answer', %q{
  In order to delete answer
  As an authenticated user
  I want to be able delete my answer
} do

  given(:question) { create(:question) }
  given(:user) { create(:user) }
  given(:user2) { create(:user) }
  given(:answer) { Answer.create(body: 'Test answer', user: user, question: question) }
  given(:answer2) { Answer.create(body: 'Test answer', user: user2, question: question) }

  before { sign_in(user) }

  scenario 'Authenticated user can delete his answer' do
    answer
    visit question_path(question)
    click_on 'Delete answer'
    expect(page).to have_content 'Answer succefully deleted'
    expect(current_path).to eq question_path(question)
  end

  scenario 'Authenticated user can not delete not his answer' do
    answer2
    visit question_path(question)

    expect(page).to_not have_link 'Delete answer'
  end

  scenario 'Non-authenticated user can non delete any answer' do
    answer2
    visit question_path(question)

    expect(page).to_not have_link 'Delete answer'
  end

end