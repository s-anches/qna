require 'rails_helper'

feature 'User can delete his question', %q{
  In order to delete question
  As an authenticated user
  I want to be able delete my question
} do

  given(:user_one) { create(:user) }
  given(:user_two) { create(:user) }
  given(:question) { create(:question, user: user_one) }

  scenario 'Authenticated user can delete his question' do
    sign_in(user_one)

    visit question_path(question)
    click_on 'Delete'

    expect(page).to have_content 'Question succesfully deleted.'
    expect(current_path).to eq root_path

  end

  scenario 'Authenticated user can not delete not his question' do
    sign_in(user_two)

    visit question_path(question)
    expect(page).to_not have_link 'Delete'
  end

  scenario 'Non-authenticated user can not delete any question' do
    visit question_path(question)
    expect(page).to_not have_link 'Delete'
  end

end