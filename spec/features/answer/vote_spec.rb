require 'rails_helper'

feature 'User can upvote, downvote or clear their vote for an answer', %q{
  In order to alter the rating of an answer
  As an authenticated user
  I'd like to be able vote on an answer
} do
  given(:user) { create(:user) }
  given(:other_user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given!(:answer_authored) { create(:answer, question: question, user: user) }
  given!(:answer_unauthored) { create(:answer, question: question, user: other_user) }

  describe 'Authenticated user', js: true do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'upvotes an answer' do
      within page.find(class: 'answer', text: answer_unauthored.body) do
        find(class: 'upvote').click

        expect(find(class: 'score')).to have_text 1
      end
    end

    scenario 'undoes their upvote' do
      within page.find(class: 'answer', text: answer_unauthored.body) do
        find(class: 'upvote').click
        find(class: 'upvote').click

        expect(find(class: 'score')).to have_text 0
      end
    end

    scenario 'downvotes an answer' do
      within page.find(class: 'answer', text: answer_unauthored.body) do
        find(class: 'downvote').click

        expect(find(class: 'score')).to have_text -1
      end
    end

    scenario 'undoes their downvote' do
      within page.find(class: 'answer', text: answer_unauthored.body) do
        find(class: 'downvote').click
        find(class: 'downvote').click

        expect(find(class: 'score')).to have_text 0
      end
    end

    scenario 'tries to vote for their own answer' do
      expect(page.find(class: 'answer', text: answer_authored.body)).to_not have_link '▲'
      expect(page.find(class: 'answer', text: answer_authored.body)).to_not have_link '▼'
    end
  end

  describe 'Unauthenticated user', js: true do
    scenario 'tries to vote' do
      visit question_path(question)

      expect(page.find(class: 'answer', text: answer_unauthored.body)).to_not have_link '▲'
      expect(page.find(class: 'answer', text: answer_unauthored.body)).to_not have_link '▼'
    end
  end
end