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
    fill_in 'Title of question...', with: "Title of question with files"
    fill_in 'Your question...', with: "Body of question with files"
    within all('.nested-fields').first do
      attach_file 'File', "#{Rails.root}/config.ru"
    end
    click_on 'Add'
    within all('.nested-fields').last do
      attach_file 'File', "#{Rails.root}/Gemfile"
    end
    click_on 'Create'

    expect(page).to have_link 'config.ru',
                    href: '/uploads/attachment/file/1/config.ru'
    expect(page).to have_link 'Gemfile',
                    href: '/uploads/attachment/file/2/Gemfile'
  end

end
