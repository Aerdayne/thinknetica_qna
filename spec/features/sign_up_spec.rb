require 'rails_helper'

feature 'User can sign up', %q{
  In order to ask questions
  As an unauthenticated user
  I'd like to be able to sign up
} do
  background { visit new_user_registration_path }

  scenario 'User signs up with valid credentials' do
    fill_in 'Email', with: 'test@test.test'
    fill_in 'Password', with: 'testtest'
    fill_in 'Password confirmation', with: 'testtest'
    click_on 'Sign up'

    expect(page).to have_content 'Welcome! You have signed up successfully.'
  end

  describe 'User attempts to sign up with' do
    given(:user) { create(:user) }

    scenario 'invalid email' do
      fill_in 'Email', with: 'test'
      fill_in 'Password', with: 'testtest'
      fill_in 'Password confirmation', with: 'testtest'
      click_on 'Sign up'

      expect(page).to have_content 'Email is invalid'
    end

    scenario 'email which has been already taken' do
      fill_in 'Email', with: user.email
      fill_in 'Password', with: 'testtest'
      fill_in 'Password confirmation', with: 'testtest'
      click_on 'Sign up'

      expect(page).to have_content 'Email has already been taken'
    end

    scenario 'invalid password' do
      fill_in 'Email', with: 'test@test.test'
      fill_in 'Password', with: 'test'
      fill_in 'Password confirmation', with: 'test'
      click_on 'Sign up'

      expect(page).to have_content 'Password is too short (minimum is 6 characters)'
    end

    scenario 'invalid password confirmation' do
      fill_in 'Email', with: 'test@test.test'
      fill_in 'Password', with: 'testtest'
      click_on 'Sign up'

      expect(page).to have_content "Password confirmation doesn't match Password"
    end
  end
end