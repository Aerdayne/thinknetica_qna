require 'rails_helper'

feature 'User can view the list of questions', %q{
  In order to search for an already asked question
  Both as an authenticated and unauthenticated user
  I'd like to be able to view all existing questions
} do
  given(:user) { create(:user) }
  given!(:questions) { create_list(:question, 5, user: user) }

  scenario 'Authenticated user views the list of all questions' do
    sign_in(user)
    visit questions_path

    questions.each do |question|
      expect(page).to have_content question.title
    end
  end

  scenario 'Unauthenticated user tries to view the list of all questions' do
    visit questions_path

    questions.each do |question|
      expect(page).to have_content question.title
    end
  end
end