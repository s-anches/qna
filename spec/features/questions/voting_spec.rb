require_relative '../../../spec/feature_helper'

feature 'Voting for question', %q{
  In order to be able voting for question
  As an authenticated user
  I want to be able voting
} do

  given(:user) { create :user }
  given(:question) { create :question, user: user }
  given(:foreign_question) { create :question }

  describe 'Authenticated user' do
    scenario 'can not voting for his question', js: true do
      sign_in user
      visit question_path(question)

      expect(page).to_not have_link '+1'
    end

    scenario 'can voting for foreign question only once', js: true do
      sign_in user
      visit question_path(foreign_question)

      click_on '+1'
      expect(page).to have_content 'Votes: 1'
      click_on '+1'
      expect(page).to have_content 'Votes: 1'
      expect(page).to have_content 'Access forbidden or you already voted'
    end
  end

  scenario 'Non-authenticated user can not voting for question' do
    visit question_path(question)

    expect(page).to_not have_link '+1'
  end

end
