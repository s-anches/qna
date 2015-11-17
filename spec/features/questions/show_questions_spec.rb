require_relative '../../../spec/feature_helper'

feature 'User can see questions', %q{
  In order to be able to see questions
  User go to root page
  User sees all questions
} do

  given(:questions) { create_list(:question, 5) }
  before { questions }

  scenario 'User try to see all questions' do
    visit root_path

    questions.each do |question|
      expect(page).to have_link question.title
      expect(page).to have_content question.body
    end
  end

end