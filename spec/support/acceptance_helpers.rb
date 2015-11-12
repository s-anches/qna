module AcceptanceHelper
  def save_new_question(title, body)
    visit new_question_path
    fill_in "Title", with: title
    fill_in "Body", with: body
    click_on 'Create'
  end
end