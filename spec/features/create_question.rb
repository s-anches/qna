require 'rails_helper'

feature 'User can create new question', %q{
  In order to be able to ask question
} do

  scenario 'User try to create new question with valid parameters' do
    save_new_question("Title", "Body")

    expect(page).to have_content "New question successfully created"
  end

  scenario 'User try to create new question with invalid parameters' do
    save_new_question(nil, nil)

    expect(page).to have_content "Some errors occured"
  end

end