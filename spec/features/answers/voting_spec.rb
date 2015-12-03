require_relative '../../../spec/feature_helper'

feature 'Voting for answer', %q{
  In order to be able voting for answer
  As an authenticated user
  I want to be able voting
} do

  given(:user) { create :user }
  given(:user_two) { create :user }
  given(:question) { create :question }
  given!(:answer) { create :answer, question: question, user: user }
  given!(:foreign_answer) { create :answer, question: question }

  describe 'Authenticated user' do
    before do
      sign_in user
      visit question_path(question)
    end

    scenario 'can like foreign answer only once time', js: true do
      within '.answers' do
        find(".answer-like-link[data-id='#{foreign_answer.id}']").click

        expect(page).to have_content 'Rating: 1'

        expect(page).to_not have_css 'a.answer-like-link'
        expect(page).to have_css 'a.answer-unvote-link'
        expect(page).to have_css 'a.liked'

        find(".answer-unvote-link[data-id='#{foreign_answer.id}']").click
        expect(page).to have_content 'Rating: 0'
      end
    end

    scenario 'can dislike foreign answer only once time', js: true do
      within '.answers' do
        find(".answer-dislike-link[data-id='#{foreign_answer.id}']").click

        expect(page).to have_content 'Rating: -1'

        expect(page).to_not have_css 'a.answer-dislike-link'
        expect(page).to have_css 'a.answer-unvote-link'
        expect(page).to have_css 'a.disliked'

        find(".answer-unvote-link[data-id='#{foreign_answer.id}']").click
        expect(page).to have_content 'Rating: 0'
      end
    end

    scenario 'can change his resolution', js: true do
      within '.answers' do
        find(".answer-like-link[data-id='#{foreign_answer.id}']").click
        expect(page).to have_content 'Rating: 1'

        find(".answer-unvote-link[data-id='#{foreign_answer.id}']").click

        expect(page).to have_content 'Rating: 0'
        find(".answer-dislike-link[data-id='#{foreign_answer.id}']").click

        expect(page).to have_content 'Rating: -1'
      end
    end

    scenario 'can not voting for his answer', js: true do
      within '.answers' do
        visit question_path(question)

        expect(page).to_not have_css "a.answer-like-link[data-id='#{answer.id}']"
        expect(page).to_not have_css "a.answer-dislike-link[data-id='#{answer.id}']"
      end
    end
  end

  describe 'Non-authenticated user' do
    before { visit question_path(question) }

    scenario 'can not voting' do
      within '.answers' do
        expect(page).to_not have_css 'a.answer-like-link'
        expect(page).to_not have_css 'a.answer-dislike-link'
      end
    end
  end

  scenario 'All can see rating', js: true do
      sign_in user
      visit question_path(question)
      within '.answers' do
        find(".answer-like-link[data-id='#{foreign_answer.id}']").click

        expect(page).to have_content 'Rating: 1'
      end

      sign_out
      visit question_path(question)

      within '.answers' do
        expect(page).to have_content 'Rating: 1'
      end
  end

end
