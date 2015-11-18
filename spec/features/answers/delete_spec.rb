require_relative "../../../spec/feature_helper"

feature 'User can delete his answer', %q{
  In order to delete answer
  As an authenticated user
  I want to be able delete my answer
} do

  given(:user_one) { create(:user) }
  given(:user_two) { create(:user) }
  given(:answer_one) { create(:answer, user: user_one) }
  given(:answer_two) { create(:answer, user: user_two) }

  scenario 'Authenticated user can delete his answer', js: true do
    sign_in(user_one)
    visit question_path(answer_one.question)
    click_on 'Delete'

    expect(page).to have_content 'Answer succefully deleted'
    expect(page).to_not have_content answer_one.body
  end

  scenario 'Authenticated user can not delete not his answer' do
    sign_in(user_one)
    visit question_path(answer_two.question)

    expect(page).to_not have_link 'Delete'
  end

  scenario 'Non-authenticated user can non delete any answer' do
    visit question_path(answer_one.question)

    expect(page).to_not have_link 'Delete'
  end

end
