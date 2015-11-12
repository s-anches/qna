require 'rails_helper'

feature 'User can create new question', %q{
  In order to be able to ask question
  User go to new question page, fill need field and click save
  User redirect to new question page or saw error
} do

  scenario 'User try to create new question with valid parameters' do
    save_new_question("Title", "Body")

    expect(page).to have_content "New question successfully created"
  end

  scenario 'User try to create new question with invalid parameters' do
    save_new_question

    expect(page).to have_content "Some errors occured"
  end

end