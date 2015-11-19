require_relative "../../../spec/feature_helper"

feature "User can choose best answer", %q{
  In order to be able to choose best answer
  As an authenticated user
  I want to be able choose best answer to question
} do

  given(:user) { create :user }
  given(:own_question) { create :question, user: user }
  given(:foreign_question) { create :question }
  given!(:answer) { Answer.create(body: "Test", user: user, question: own_question) }
  given!(:answer_one) { create :answer, question: own_question }
  given!(:answer_two) { create :answer, question: own_question }

  scenario "Non-authenticated user" do
    visit question_path(own_question)

    expect(page).to_not have_link "Best"
  end

  describe "Authenticated user", js: true do
    before { sign_in user }

    scenario "Author trying to choose best answer" do
      visit question_path(own_question)
      click_on "set-best-link-#{answer_one.id}"

      within ".answer[data-id='#{answer_one.id}']" do
        expect(page).to have_css ".best"
        expect(page).to have_css ".disabled"
      end
    end

    scenario "Author trying to change best answer" do
      visit question_path(own_question)

      click_on "set-best-link-#{answer_one.id}"
      within ".answer[data-id='#{answer_one.id}']" do
        expect(page).to have_css ".best"
        expect(page).to have_css ".disabled"
      end

      click_on "set-best-link-#{answer_two.id}"
      within ".answer[data-id='#{answer_two.id}']" do
        expect(page).to have_css ".best"
        expect(page).to have_css ".disabled"
      end

      within ".answer[data-id='#{answer_one.id}']" do
        expect(page).to_not have_css ".best"
        expect(page).to_not have_css ".disabled"
      end
    end

    scenario "Non-author trying to choose best answer" do
      visit question_path(foreign_question)

      expect(page).to_not have_link "Best"
    end

    scenario "All users sees best answer", js: true do
      visit question_path(own_question)
      click_on "set-best-link-#{answer_one.id}"
      sign_out
      visit question_path(own_question)

      expect(page).to have_css ".best"
      expect(page).to have_css ".disabled"
    end

    scenario "Best answer show on top of list", js: true do
      visit question_path(own_question)

      expect(answer.body).to have_content first(".answer p").text
      expect(answer_two.body).to_not have_content first(".answer p").text

      click_on "set-best-link-#{answer_two.id}"
      sleep(1)

      expect(answer_two.body).to have_content first(".answer p").text
      expect(answer.body).to_not have_content first(".answer p").text
    end
  end

end