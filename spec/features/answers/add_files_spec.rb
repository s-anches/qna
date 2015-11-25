require_relative '../../../spec/feature_helper'

feature 'Add files to answer', %q{
  In order to be add more info to my answer
  As an answer author
  I want to be able to attach files
} do

  given(:user) { create :user }
  given(:question) { create :question }

  background do
    sign_in user
    visit question_path(question)
  end

  scenario 'User adds files when save answer', js: true do
    within '#new_answer' do
      fill_in 'Your answer...', with: "Body of answer"
      click_on 'Add'
      all("input[type='file']").first.set("#{Rails.root}/config.ru")
      all("input[type='file']").last.set("#{Rails.root}/Gemfile")
      click_on 'Create'
    end

    within '.answers' do
      expect(page).to have_link 'config.ru',
                    href: '/uploads/attachment/file/1/config.ru'
      expect(page).to have_link 'Gemfile',
                    href: '/uploads/attachment/file/2/Gemfile'
    end
  end

end
