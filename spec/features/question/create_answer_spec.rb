require 'rails_helper'

feature 'User can answer a question', %q{
  In order to give an answer to an existing question
  As an authenticated user
  I'd like to be able to answer a question
} do
  given(:user) { create(:user) }
  given(:question) { create(:question, user: user ) }

  describe 'Authenticated user' do
    background do
      sign_in(user)

      visit question_path(question)
      click_on 'Answer'
    end

    scenario 'answers a question' do
      fill_in 'Body', with: 'this is an answer'
      click_on 'Answer'

      expect(page).to have_content 'Your answer has been successfully created.'
      expect(page).to have_content 'this is an answer'
    end

    scenario 'answers with errors' do
      click_on 'Answer'

      expect(page).to have_content "Body can't be blank"
    end
  end

  scenario 'Unauthenticated user tries to answer a question' do
    visit question_path(question)
    click_on 'Answer'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end