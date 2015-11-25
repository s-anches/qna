require_relative "../../../spec/feature_helper"

feature "User can edit question", %q{
  In order to be able edit question
  As an authenticated user
  I want to be able to edit question
} do

  given(:user) { create :user }
  given(:own_question) { create :question, user: user }
  given(:foreign_question) { create :question }

  scenario "Non-authenticated user trying edit question" do
    visit question_path(own_question)

    expect(page).to_not have_link "Edit"
  end

  describe "Authenticated user" do
    before { sign_in(user) }

    scenario "Author trying to edit his question", js: true do
      visit question_path(own_question)

      within ".question" do
        find(".edit-question-link").click
      end
      within ".question-edit" do
        fill_in "question_body", with: "Edited body"
        click_on "Save"
      end
      within ".question" do
        expect(page).to have_content "Edited body"
        expect(page).to_not have_selector "textarea"
      end
    end

    scenario "Non-author trying to edit other owner's question" do
      visit question_path(foreign_question)

      expect(page).to_not have_link "Edit"
    end
  end

end
