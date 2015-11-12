require 'rails_helper'

feature 'User can sign in', %q{
  In order to be able to sign in
  As an anonymous user
  I want to be able to sign in
} do

  scenario 'Registered user try to sign in' do
    User.create!(email: "user@example.com", password: "12345678")

    visit new_user_session_path
    fill_in "Email", with: "user@example.com"
    fill_in "Password", with: "12345678"
    click_on "Log in"

    expect(page).to have_content "Signed in successfully."
    expect(current_path).to eq root_path
  end

  scenario 'Un-registered user try to sign in' do
    visit new_user_session_path
    fill_in "Email", with: "non-user@example.com"
    fill_in "Password", with: "12345678"
    click_on "Log in"
    
    expect(page).to have_content "Invalid email or password."
    expect(current_path).to eq new_user_session_path
  end

end