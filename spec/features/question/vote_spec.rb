require 'rails_helper'

feature 'User can upvote, downvote or clear their vote for a question', %q{
  In order to alter the rating of a question
  As an authenticated user
  I'd like to be able vote on a question
} do
  given(:user) { create(:user) }
  given(:other_user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given(:question_unauthored) { create(:question, user: other_user) }

  describe 'Authenticated user', js: true do
    background do
      sign_in(user)
    end

    scenario 'upvotes a question' do
      visit question_path(question_unauthored)

      within '.question' do
        find(class: 'upvote').click

        expect(find(class: 'score')).to have_text 1
      end
    end

    scenario 'undoes their upvote' do
      visit question_path(question_unauthored)

      within '.question' do
        find(class: 'upvote').click
        find(class: 'upvote').click

        expect(find(class: 'score')).to have_text 0
      end
    end

    scenario 'downvotes a question' do
      visit question_path(question_unauthored)

      within '.question' do
        find(class: 'downvote').click

        expect(find(class: 'score')).to have_text -1
      end
    end

    scenario 'undoes their downvote' do
      visit question_path(question_unauthored)

      within '.question' do
        find(class: 'downvote').click
        find(class: 'downvote').click

        expect(find(class: 'score')).to have_text 0
      end
    end

    scenario 'tries to vote for their own question' do
      visit question_path(question)

      expect(find(class: 'question')).to_not have_link '▲'
      expect(find(class: 'question')).to_not have_link '▼'
    end
  end

  describe 'Unauthenticated user', js: true do
    scenario 'tries to vote' do
      visit question_path(question)

      expect(find(class: 'question')).to_not have_link '▲'
      expect(find(class: 'question')).to_not have_link '▼'
    end
  end
end