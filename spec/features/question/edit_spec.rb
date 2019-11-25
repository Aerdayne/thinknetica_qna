require 'rails_helper'

feature 'User can edit their own question', %q{
  In order to edit my question
  As an authenticated user
  I'd like ot be able to edit my own question
} do
  given(:user) { create(:user) }
  given(:other_user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:question_unauthored) { create(:question, user: other_user)}

  scenario 'Unathenticated user can not edit question' do
    visit question_path(question)

    expect(page).to_not have_link 'Edit'
  end

  describe 'Authenticated user', js: true do
    before do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'edits their question' do
      within '.question' do
        click_on 'Edit'
        fill_in 'Question title', with: 'new title'
        fill_in 'Question contents', with: 'new body'

        click_on 'Save'

        expect(page).to have_content 'new title'
        expect(page).to have_content 'new body'
        expect(page).to_not have_content question.body
        expect(page).to_not have_content question.title
        expect(page).to_not have_selector 'textarea'
      end
    end

    scenario 'edits their question with errors' do
      within '.question' do
        click_on 'Edit'
        fill_in 'Question contents', with: ''
        click_on 'Save'
      end

      expect(page).to have_content question.body
      expect(page).to have_content "Body can't be blank"
    end

    scenario "tries to edit other user's question" do
      visit question_path(question_unauthored)

      expect(page).to_not have_link 'Edit'
    end
  end
end