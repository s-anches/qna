require_relative '../../../spec/feature_helper'

feature 'Add files to question', %q{
  In order to be add more info to my question
  As an question author
  I want to be able to attach files
} do

  given(:user) { create :user }
  given!(:question) { create :question, user: user }
  background do
    sign_in user
  end

  describe 'from new form' do
    before do
      visit new_question_path
    end

    scenario 'User can add files when ask question', js: true do
      fill_in 'Title of question...', with: "Title of question with files"
      fill_in 'Your question...', with: "Body of question with files"
      click_on 'Add'
      all("input[type='file']").first.set("#{Rails.root}/config.ru")
      all("input[type='file']").last.set("#{Rails.root}/Gemfile")
      click_on 'Create'

      expect(page).to have_link 'config.ru',
                      href: '/uploads/attachment/file/1/config.ru'
      expect(page).to have_link 'Gemfile',
                      href: '/uploads/attachment/file/2/Gemfile'
    end
  end

  describe 'from edit form' do
    before do
      visit question_path(question)
    end

    scenario 'User can add files when edit his question', js: true do
      find(".edit-question-link").click
      within '.edit_question' do
        click_on 'Add'
        find("input[type='file']").set("#{Rails.root}/config.ru")
        click_on 'Save'
      end

      expect(page).to have_link 'config.ru',
                      href: '/uploads/attachment/file/1/config.ru'
    end
  end
end
