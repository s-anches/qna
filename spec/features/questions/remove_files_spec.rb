require_relative '../../../spec/feature_helper'

feature 'Remove files from question', %q{
  In order to be remove files from my question
  As an question author
  I want to be able to remove file
} do

  given(:user) { create :user }
  given(:question) { create :question, user: user }
  given!(:attachment) { create :attachment, attachable: question }

  given(:foreign_question) { create :question }
  given!(:foreign_attachment) { create :attachment, attachable: foreign_question }


  background do
    sign_in user
  end

  describe 'User can remove files from his question' do
    before { visit question_path(question) }
    scenario 'can remove from edit form', js: true do
      expect(page).to have_link attachment.file.filename

      find('.edit-question-link').click
      check("remove-attachment-#{attachment.id}")
      click_on 'Save'

      expect(page).to_not have_link 'Gemfile'
      expect(page).to_not have_content 'Gemfile'
      expect(page).to_not have_button 'Save'
    end
  end

  describe 'Non-author question try to remove attachment' do
    before { visit question_path(foreign_question) }
    scenario 'can not remove attachments from question' do
      expect(page).to have_link 'Gemfile'
      expect(page).to_not have_link '.edit-question-link'
    end
  end
end
