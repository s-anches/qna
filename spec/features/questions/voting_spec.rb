require_relative '../../../spec/feature_helper'

feature 'Voting for question', %q{
  In order to be able voting for question
  As an authenticated user
  I want to be able voting
} do

  given(:user) { create :user }
  given(:question) { create :question }

  scenario 'Authenticated user can voting for question', js: true do
    sign_in user
    visit question_path(question)

    click_on '+1'
    expect(page).to have_content 'Votes: +1'
  end

  scenario 'Non-authenticated user can not voting for question'

end
