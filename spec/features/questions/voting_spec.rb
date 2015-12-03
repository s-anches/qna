require_relative '../../../spec/feature_helper'

feature 'Voting for question', %q{
  In order to be able voting for question
  As an authenticated user
  I want to be able voting
} do

  given(:user) { create :user }
  given(:user_two) { create :user }
  given(:question) { create :question, user: user }
  given(:foreign_question) { create :question }

  describe 'Authenticated user' do
    before do
      sign_in user
      visit question_path(foreign_question)
    end

    scenario 'can like foreign question only once time', js: true do
      find('.question-like-link').click

      expect(page).to have_content 'Rating: 1'

      expect(page).to_not have_css 'a.question-like-link'
      expect(page).to have_css 'a.question-unvote-link'
      expect(page).to have_css 'a.liked'

      find('.question-unvote-link').click
      expect(page).to have_content 'Rating: 0'
    end

    scenario 'can dislike foreign question only once time', js: true do
      find('.question-dislike-link').click

      expect(page).to have_content 'Rating: -1'

      expect(page).to_not have_css 'a.question-dislike-link'
      expect(page).to have_css 'a.question-unvote-link'
      expect(page).to have_css 'a.disliked'

      find('.question-unvote-link').click
      expect(page).to have_content 'Rating: 0'
    end

    scenario 'can change his resolution', js: true do
      find('.question-like-link').click
      expect(page).to have_content 'Rating: 1'

      find('.question-unvote-link').click

      expect(page).to have_content 'Rating: 0'
      find('.question-dislike-link').click

      expect(page).to have_content 'Rating: -1'
    end

    scenario 'can not voting for his question', js: true do
      visit question_path(question)

      expect(page).to_not have_css 'a.question-like-link'
      expect(page).to_not have_css 'a.question-dislike-link'
    end
  end

  describe 'Non-authenticated user' do
    before { visit question_path(question) }

    scenario 'can not voting' do
      expect(page).to_not have_css 'a.question-like-link'
      expect(page).to_not have_css 'a.question-dislike-link'
    end
  end

  scenario 'All can see rating', js: true do
      sign_in user
      visit question_path(foreign_question)
      find('.question-like-link').click

      expect(page).to have_content 'Rating: 1'

      sign_out
      sign_in user_two
      visit question_path(foreign_question)
      find('.question-dislike-link').click

      expect(page).to have_content 'Rating: 0'

      sign_out
      visit question_path(foreign_question)
      expect(page).to have_content 'Rating: 0'
  end

end
