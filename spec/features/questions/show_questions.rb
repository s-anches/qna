require 'rails_helper'

feature 'User can see questions', %q{
  In order to be able to see questions
  User go to root page
  User sees all questions
} do

  scenario 'User try to see all questions' do
    Question.create!(title: "Test", body: "Test question")
    Question.create!(title: "Test 2", body: "Test question 2")

    visit root_path
    expect(page).to have_link "Test"
    expect(page).to have_content "Test question"
    expect(page).to have_link "Test 2"
    expect(page).to have_content "Test question 2"
  end

end