require 'rails_helper'

feature 'User can delete their own answer', %q{
  In order to delete my answer
  As an authenticated user
  I'd like to be able to delete my own answer
} do
  given(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, user: user, question: question) }
  given(:other_user) { create(:user) }
  given!(:answer_unauthored) { create(:answer, :other, user: other_user, question: question) }

  describe 'Authenticated user' do
    background do
      sign_in(user)
    end

    scenario 'deletes their own answer' do
      visit question_path(question)
      find(class: "row", text: answer.body).click_on 'Delete'

      expect(page).to have_text 'Your answer has been successfully removed'
    end

    scenario 'tries to delete others\' answer' do
      visit question_path(question)

      expect(page.find(class: "row", text: answer_unauthored.body)).to_not have_link 'Delete'
    end
  end

  scenario 'Unauthenticated user does not have an option to delete' do
    visit question_path(question)

    expect(page.find(class: "row", text: answer.body)).to_not have_link 'Delete'
  end
end