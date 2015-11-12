require 'rails_helper'

feature 'User can delete his answer', %q{
  In order to delete answer
  As an authenticated user
  I want to be able delete my answer
} do

  given(:question) { create(:question_with_answers) }
  scenario 'Authenticated user can delete his answer' do
    question.answers.each do |answer|
      visit "/questions/#{question.id}/answers/#{answer.id}"

      click_on 'Delete'
      expect(page).to have_content 'Answer succefully deleted.'
      expect(current_path).to eq question_path(question)
    end
  end
  scenario 'Authenticated user can not delete not his answer' do

  end
  scenario 'Non-authenticated user can non delete any answer' do

  end

end