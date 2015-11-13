require 'rails_helper'

feature 'User can see all answers to question', %q{
  In order to be able see all answers to question
  User need go to question page
  User sees all answers to this question
} do

  given(:question) { create(:question) }
  given(:answers) { create_list(:answer, 5, question: question) }

  before { answers }

  scenario 'User try to see question and all answers' do
    visit question_path(question)

    expect(page).to have_content(question.title)
    expect(page).to have_content(question.body)

    answers.each do |answer|
      expect(page).to have_content(answer.body)
    end
  end

end