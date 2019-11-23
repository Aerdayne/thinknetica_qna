require 'rails_helper'

feature 'User can view questions and related answers', %q{
  In order to view existing answers to a question
  Both as an authenticated and unauthenticated user
  I'd like to be able to view questions and existing answers to them
} do
  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given!(:answers) { create_list(:answer, 5, user: user, question: question) }

  scenario 'Authenticated user views a question and related answers' do
    sign_in(user)
    visit question_path(question)

    answers.each do |answer|
      expect(page).to have_content answer.question.title
      expect(page).to have_content answer.question.body
      expect(page).to have_content answer.body
    end
  end

  scenario 'Unauthenticated user tries to ask a question' do
    visit question_path(question)

    answers.each do |answer|
      expect(page).to have_content question.title
      expect(page).to have_content question.body
      expect(page).to have_content answer.body
    end
  end
end