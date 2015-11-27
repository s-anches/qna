module AcceptanceHelper
  def save_new_question(title = nil, body = nil)
    visit new_question_path
    fill_in 'Title of question...', with: title
    fill_in 'Your question...', with: body
    click_on 'Create'
  end

  def save_new_answer(question, body = nil)
    visit question_path(question)

    fill_in "Your answer...", with: body
    click_on 'Create'
  end

  def sign_in(user)
    visit new_user_session_path
    within '#new_user' do
      fill_in 'Email', with: user.email
      fill_in 'Password', with: user.password
      click_on 'Log in'
    end
  end

  def sign_out
    visit root_path
    click_on 'Sign out'
  end
end
