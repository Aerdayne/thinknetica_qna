require 'rails_helper'

feature 'User can mark an answer as the best one', %q{
  In order to mark the best answer
  As an authenticated user
  I'd like to be able mark an answer to my question as the best one
} do
  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given!(:answers) { create_list(:answer, 5, user: user, question: question) }
  given(:other_user) { create(:user) }
  given!(:question_unauthored) { create(:question, user: other_user) }
  given!(:answer_unauthored) { create(:answer, user: other_user, question: question_unauthored) }

  describe 'Authenticated user', js: true do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'chooses the best answer' do
      within '.answers' do
        last_answer = page.find(".answer[data-id='#{answers.last.id}']")
        last_answer.click_on 'Mark as best'

        expect(page.find(class: 'answer', match: :first)).to have_content last_answer.text
      end
    end

    scenario 'tries to mark other\'s question\'s answer as best', js: true do
      visit question_path(question_unauthored)

      expect(page).to_not have_link 'Mark as best'
    end
  end

  scenario 'Unauthenticated user tries to choose the best answer' do
    visit question_path(question)

    expect(page).to_not have_link 'Mark as best'
  end
end