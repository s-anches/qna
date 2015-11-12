module AcceptanceHelper
  def save_new_question(title = nil, body = nil)
    visit new_question_path
    fill_in 'Title', with: title
    fill_in 'Body', with: body
    click_on 'Create'
  end

  def save_new_answer(question, body = nil)
    visit new_question_answer_path(question)

    fill_in 'Body', with: body
    click_on 'Create'
  end

  def sign_in(user)
    visit new_user_session_path
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_on 'Log in'
  end
end