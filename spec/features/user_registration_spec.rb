require 'rails_helper'

feature 'User can registration', %q{
  In order to be able to register
  As an anonymous user
  I want to be able to register
} do

  scenario 'Anonymous user try to register' do
    visit new_user_registration_path

    fill_in 'Email',                  with: 'user@example.com'
    fill_in 'Password',               with: '12345678'
    fill_in 'Password confirmation',  with: '12345678'
    click_on 'Sign up'

    expect(page).to have_content 'Welcome! You have signed up successfully.'
    expect(current_path).to eq root_path
  end

end