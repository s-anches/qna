require 'rails_helper'

feature 'User can sign out', %q{
  In order to be able to sign out
  As an authenticated user
  I want to be able to sign out
} do

  given(:user) { create(:user) }

  scenario 'Authenticated user try to sign out' do
    sign_in(user)

    expect(page).to have_content 'Signed in successfully.'
    expect(current_path).to eq root_path

    click_on 'Sign out'
    expect(current_path).to eq root_path
    expect(page).to have_content 'Signed out successfully.'
  end

end