require 'rails_helper'

feature 'User can mark an answer as the best one', %q{
  In order to mark the best answer
  As an authenticated user
  I'd like to be able to mark an answer to my question as the best one
} do
  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given!(:answers) { create_list(:answer, 5, user: user, question: question) }
  given(:other_user) { create(:user) }
  given!(:question_unauthored) { create(:question, user: other_user) }
  given!(:answer_unauthored) { create(:answer, user: other_user, question: question_unauthored) }

  given(:question_with_reward) { create(:question, user: user) }
  given!(:reward) { create(:reward, question: question_with_reward, file: fixture_file_upload(Rails.root.join('public', 'reward.png'), 'image/png'))}
  given!(:answer_to_a_question_with_reward) { create(:answer, user: other_user, question: question_with_reward) }

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

    scenario 'tries to mark other\'s question\'s answer as best' do
      visit question_path(question_unauthored)

      expect(page).to_not have_link 'Mark as best'
    end

    scenario 'marks the best answer and gives a reward to the answer\'s author' do
      visit question_path(question_with_reward)

      within '.answers' do
        find(".answer[data-id='#{answer_to_a_question_with_reward.id}']")
        click_on 'Mark as best'
      end

      click_on 'Sign out'
      sign_in(other_user)

      visit rewards_path
      expect(page).to have_text reward.name
      expect(page).to have_link reward.file.filename.to_s
    end
  end

  scenario 'Unauthenticated user tries to choose the best answer' do
    visit question_path(question_with_reward)

    expect(page).to_not have_link 'Mark as best'
  end
end