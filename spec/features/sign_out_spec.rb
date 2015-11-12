require 'rails_helper'

feature 'User can sign out', %q{
  In order to be able to sign out
  As an authenticated user
  I want to be able to sign out
} do

  scenario 'Authenticated user try to sign out' do
    User.create!(email: 'user@example.com', password: '12345678')

    visit new_user_session_path
    fill_in 'Email', with: 'user@example.com'
    fill_in 'Password', with: '12345678'
    click_on 'Log in'

    expect(page).to have_content "Signed in successfully."
    expect(current_path).to eq root_path

    click_on 'Sign out'
    expect(current_path).to eq root_path
    expect(page).to have_content 'Signed out successfully.'
  end

end