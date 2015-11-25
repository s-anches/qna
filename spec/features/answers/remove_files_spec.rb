require_relative '../../../spec/feature_helper'

feature 'Remove files from answer', %q{
  In order to be remove files from my answer
  As an answer author
  I want to be able to remove file
} do

  given(:user) { create :user }
  given(:question) { create :question, user: user }
  given!(:answer) { create :answer, question: question, user: user }
  given!(:attachment) { create :attachment, attachable: answer }

  given!(:foreign_answer) { create :answer, question: question }
  given!(:foreign_attachment) { create :attachment, attachable: foreign_answer }

  background do
    sign_in user
    visit question_path(question)
  end

  describe 'User can remove files from his answer' do
    scenario 'can remove from edit form', js: true do
      expect(page).to have_link attachment.file.filename

      within(".answer[data-id='#{answer.id}']") do
        find('.edit-answer-link').click
        check("remove-attachment-#{attachment.id}")
        click_on 'Save'
        expect(page).to_not have_link 'Gemfile'
        expect(page).to_not have_content 'Gemfile'
        expect(page).to_not have_button 'Save'
      end
    end
  end

  describe 'Non-author answer try to remove attachment' do
    scenario 'can not remove attachments from answer' do
      within ".answer[data-id='#{foreign_answer.id}']" do
        expect(page).to have_link foreign_attachment.file.filename
        expect(page).to_not have_link '.edit-answer-link'
      end
    end
  end

end
