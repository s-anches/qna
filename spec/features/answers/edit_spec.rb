require_relative "../../../spec/feature_helper"

feature "User can edit answer", %q{
  In order to be able edit answer
  As an authenticated user
  I want to be able to edit answer
} do

  given(:user) { create :user }
  given(:own_answer) { create :answer, user: user }
  given(:foreign_answer) { create :answer }

  scenario "Non-authenticated user trying to edit answer" do
    visit question_path(own_answer.question)

    within ".answers" do
      expect(page).to_not have_link "Edit"
    end
  end

  describe "Authenticated user" do
    before { sign_in(user) }

    scenario "Author trying to edit his answer", js: true do
      visit question_path(own_answer.question)

      within ".answer" do
        find(".edit-answer-link").click
        fill_in "Your answer:", with: "Edited answer"
        click_on "Save"
        expect(page).to_not have_selector "textarea"
      end

      expect(page).to have_content "Edited answer"
    end

    scenario "Non-author trying to edit other owner's answer" do
      visit question_path(foreign_answer.question)

      within ".answer" do
        expect(page).to_not have_link "Edit"
      end
    end
  end

end