require 'rails_helper'

feature 'User can delete their own question', %q{
  In order to delete my question
  As an authenticated user
  I'd like to be able to delete my own question
} do
  given(:user) { create(:user) }
  given(:question_authored) { create(:question, user: user) }
  given(:other_user) { create(:user) }
  given(:question_unauthored) { create(:question, user: other_user) }

  describe 'Authenticated user' do
    background do
      sign_in(user)
    end

    scenario 'deletes their own question' do
      visit question_path(question_authored)
      click_on 'Delete'

      expect(page).to have_text 'Your question has been successfully deleted'
    end

    scenario 'tries to delete others\' question' do
      visit question_path(question_unauthored)

      expect(page).to_not have_link 'Delete'
    end
  end

  scenario 'Unauthenticated user does not have an option to delete' do
    visit question_path(question_authored)

    expect(page).to_not have_link 'Delete'
  end
end