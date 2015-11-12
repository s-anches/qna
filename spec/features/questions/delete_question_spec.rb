require 'rails_helper'

feature 'User can delete his question', %q{
  In order to delete answer
  As an authenticated user
  I want to be able delete my question
} do

  given(:user) { create(:user_with_question) }
  given(:user2) { create(:user_with_question) }
  given(:question) { create(:question) }

  scenario 'Authenticated user can delete his question' do
    sign_in(user)

    user.questions.each do |question|
      visit question_path(question)
      click_on 'Delete'

      expect(page).to have_content 'Question succesfully deleted.'
      expect(current_path).to eq root_path
    end

  end

  scenario 'Authenticated user can not delete not his question' do
    sign_in(user)

    user2.questions.each do |question|
      visit question_path(question)
      expect(page).to_not have_link 'Delete'
    end
  end

  scenario 'Non-authenticated user can not delete any question' do
    visit question_path(question)
    expect(page).to_not have_link 'Delete'
  end

end