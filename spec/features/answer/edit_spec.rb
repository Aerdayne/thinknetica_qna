require 'rails_helper'

feature 'User can edit their own answer', %q{
  In order to edit my answer
  As an authenticated user
  I'd like ot be able to edit my own answer
} do
  given!(:user) { create(:user) }
  given!(:other_user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question, user: user) }
  given!(:unauthered_answer) { create(:answer, question: question, user: other_user) }

  scenario 'Unauthenticated can not edit answer' do
    visit question_path(question)

    expect(page).to_not have_link 'Edit'
  end

  describe 'Authenticated user', js: true do
    scenario 'edits their own answer' do
      sign_in user
      visit question_path(question)
 
      within '.answers' do
        click_on 'Edit'
        fill_in 'Your answer', with: 'edited answer'
        click_on 'Save'

        expect(page).to_not have_content answer.body
        expect(page).to have_content 'edited answer'
        expect(page).to_not have_selector 'textarea'
      end
    end

    scenario 'edits their own answer with errors' do
      sign_in user
      visit question_path(question)

      within '.answers' do
        click_on 'Edit'
        fill_in 'Your answer', with: ''
        click_on 'Save'
      end

      expect(page).to have_content answer.body
      expect(page).to have_content "Body can't be blank"
    end

    scenario "tries to edit other user's answer" do
      visit question_path(question)

      expect(page.find(class: 'answer', text: unauthered_answer.body)).to_not have_link 'Edit'
    end
  end
end