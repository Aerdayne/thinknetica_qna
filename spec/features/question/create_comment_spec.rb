require 'rails_helper'

feature 'User can comment a question', %q{
  In order to discuss an existing question without answering it
  As an authenticated user
  I'd like to be able to comment on a question
} do
  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }

  describe 'Authenticated user', js: true do
    background do
      sign_in(user)

      visit question_path(question)
    end

    scenario 'comments on a question' do
      within '.question' do
        fill_in 'Your comment', with: 'this is a comment'
        click_on 'Comment'
      end

      expect(page).to have_content 'this is a comment'
    end
  end

  scenario 'Unauthenticated user tries to comment a question' do
    visit question_path(question)

    expect(page).to_not have_link 'Comment'
  end

  describe 'Multiple sessions', js: true do
    scenario "comment appears on another user's page" do
      Capybara.using_session('user') do
        sign_in(user)
        visit question_path(question)

        within '.question' do
          fill_in 'Your comment', with: 'this is a comment'
          click_on 'Comment'
        end
        expect(page).to have_content 'this is a comment'
      end

      Capybara.using_session('guest') do
        visit question_path(question)
        expect(page).to have_content 'this is a comment'
      end
    end
  end
end