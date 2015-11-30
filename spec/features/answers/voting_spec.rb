require_relative '../../../spec/feature_helper'

feature 'Voting for answer', %q{
  In order to be able voting for answer
  As an authenticated user
  I want to be able voting
} do

  given(:user) { create :user }
  given(:question) { create :question }
  given!(:answer) { create :answer, question: question, user: user }
  given!(:foreign_answer) { create :answer, question: question }

  describe 'Authenticated user' do
    scenario 'can not voting for his answer', js: true do
      sign_in user
      visit question_path(question)

      within '.answer:first-child' do
        expect(page).to_not have_link '+1'
      end
    end

    scenario 'can voting for foreign answer', js: true do
      sign_in user
      visit question_path(question)

      within '.answers' do
        click_on '+1'

        expect(page).to have_content 'Votes: 1'
      end
    end
  end

  scenario 'Non-authenticated user can not voting for question' do
    visit question_path(question)

    expect(page).to_not have_link '+1'
  end

end
