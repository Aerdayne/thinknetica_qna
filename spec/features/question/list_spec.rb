require 'rails_helper'

feature 'User can view the list of questions', %q{
  In order to search for an already asked question
  Both as an authenticated and unauthenticated user
  I'd like to be able to view all existing questions
} do
  given(:user) { create(:user) }
  given!(:question) { create(:question, user: user)}

  describe 'Authenticated user' do
    background do
      sign_in(user)
    end

    scenario 'views the list of all questions' do
      visit questions_path

      expect(page).to have_content question.title
    end
  end

  scenario 'Unauthenticated user tries to view the list of all questions' do
    visit questions_path

    expect(page).to have_content question.title
  end
end