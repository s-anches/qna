require 'rails_helper'

feature 'User can see questions', %q{
  In order to be able to see questions
} do

  scenario 'User try to see all questions' do
    save_new_question("Title", "Body")

    expect(page).to have_content "New question successfully created"
  end

end