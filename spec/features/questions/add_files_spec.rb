require_relative '../../../spec/feature_helper'

feature 'Add files to question', %q{
  In order to be add more info to my question
  As an question author
  I want to be able to attach files
} do

  given(:user) { create :user }

  background do
    sign_in user
    visit new_question_path
  end

  scenario 'User adds files when ask question', js: true do
    fill_in 'Title of question...', with: "Title of question"
    fill_in 'Your question...', with: "Body of question"
    attach_file 'File', "#{Rails.root}/config.ru"
    click_on 'Create'

    expect(page).to have_link 'config.ru', href: '/uploads/attachment/file/1/config.ru'
  end

end